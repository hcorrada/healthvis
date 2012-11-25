from flask import render_template, request, redirect, url_for
import json
from application.models import HealthVis
from application.forms import generate_form
from datetime import datetime, timedelta
import logging
from application.settings import supported_types
from google.appengine.api import memcache
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
    var_names = json.loads(request.form['varnames'])
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

def is_memcache_obj(id):
    m=re.search(r"h(s|m)_(\d+)", id)
    if m is None:
        return False

    return m.group(1) == 'm'

def find_object(id):
    # parse id to see if the object is in memcache or datastore
    m=re.search(r"h(s|m)_(\d+)", id)
    if m is None:
        return None

    storeid = int(m.group(2))
    obj = None

    if m.group(1) == 's':
        # object stored in datastore
        obj = HealthVis.get_by_id(storeid)
    elif m.group(1) == 'm':
        # object in memcache
        obj = memcache.get(id)
    else:
        return None

    return obj

def display(id):
    obj = find_object(id)
    if obj is None:
        return render_template("500.html")
    form = generate_form(obj)

    # TODO: remove this check from local version
    if obj.type not in supported_types:
        return render_template("500.html")

    return render_template("base.html", obj=obj, form=form, plot_id=id)

def save(id):
    obj = find_object(id)
    if obj is None:
        return render_template("500.html")

    obj.saved = True
    try:
        obj.put()
    except:
        return render_template("500.html")

    if is_memcache_obj(id):
        id='hs_%d' % obj.key().id()
    return redirect(url_for('display', id=id))

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

def get_params(id):
    obj = find_object(id)
    if obj is None:
        return render_template("500.html")
    return obj.d3params
