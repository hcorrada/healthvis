from flask import render_template, request, redirect, url_for
import json
from werkzeug.http import parse_options_header

from application.models import HealthVis
from application.forms import generate_form
from datetime import datetime, timedelta
import logging
from application.settings import supported_types
from google.appengine.api import memcache
from google.appengine.ext import blobstore
from uuid import uuid4
import re

def warmup():
    """App Engine warmup handler

    """
    return ''

def index():
    return render_template('index.html')

def post_data():
    title = request.form['plottitle']
    type = request.form['plottype']
    var_list = request.form['varlist']
    var_type = json.loads(request.form['vartype'])
    # ensure var_type is a list
    if isinstance(var_type, basestring):
        var_type = [var_type]

    var_names = json.loads(request.form['varnames'])
    # ensure var_names is a list
    if isinstance(var_names, basestring):
        var_names = [var_names]

    d3params = request.form['d3Params']

    obj = HealthVis(type=type,
                    title=title,
                    var_type=var_type,
                    var_names=var_names,
                    var_list=var_list,
                    d3params=d3params)

    memcache_key='hm_%d' % uuid4()
    try:
        res=memcache.set(key=memcache_key, value=obj)
    except:
        return "error"

    if res:
        return memcache_key

    try:
        obj.put()
    except:
        return "error"
    return 'hs_%d' % obj.key().id()

def is_memcache_obj(plotid):
    m=re.search(r"h(s|m)_(\d+)", plotid)
    if m is None:
        return False

    return m.group(1) == 'm'

def find_object(plotid):
    # parse id to see if the object is in memcache or datastore
    m=re.search(r"h(s|m)_(\d+)", plotid)
    if m is None:
        return None

    storeid = int(m.group(2))
    obj = None

    if m.group(1) == 's':
        # object stored in datastore
        obj = HealthVis.get_by_id(storeid)
    elif m.group(1) == 'm':
        # object in memcache
        obj = memcache.get(plotid)
    else:
        return None

    return obj

def make_display(plotid, requestargs, template):
    obj = find_object(plotid)
    if obj is None:
        return render_template("500.html")

    # TODO: remove this check from local version
    if obj.type not in supported_types:
        return render_template("500.html")

    form = generate_form(obj, requestargs)
    return render_template(template, obj=obj, form=form, plot_id=plotid)

def display(plotid):
    return make_display(plotid, request.args, "display.html")

def embed(plotid):
    return make_display(plotid, request.args, "embed.html")


def save(plotid, query):
    obj = find_object(plotid)
    if obj is None:
        return render_template("500.html")

    upload_url = blobstore.create_upload_url(url_for('finish_save'))
    return render_template("upload_data.html", obj=obj, upload_url=upload_url, query=query)

def get_blob_key(field_name, blob_key=None):
    try:
        upload_file = request.files[field_name]
        header = upload_file.headers['Content-Type']
        parsed_header = parse_options_header(header)
        blob_key = parsed_header[1]['blob-key']
    except:
        return None
    return blob_key

def finish_save():
    blob_key = get_blob_key("fileup")
    if blob_key is None:
        return "error"

    blob_key = blobstore.BlobKey(blob_key)
    blob_reader = blobstore.BlobReader(blob_key)
    params = blob_reader.readline()

    logging.debug("read params:")

    plotid = request.values['plotid']
    obj = find_object(plotid)
    obj.saved = True
    obj.d3params = params
    try:
        obj.put()
    except:
        return "error"

    logging.debug("saved object: %d" % obj.key().id())
    return 'hs_%d' % obj.key().id()
    #return redirect(url_for('display', id=id))
    #return id

def remove_unsaved():
    now = datetime.now()
    objs = HealthVis.all().filter("saved =", False)
    for obj in objs:
        if (obj.timestamp - now) < timedelta(hours=6):
            continue

        try:
            obj.delete()
        except:
            logging.info("Couldn't delete object " + str(obj))
            continue

def get_params(plotid):
    obj = find_object(plotid)
    if obj is None:
        return render_template("500.html")
    return obj.d3params
