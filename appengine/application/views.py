from flask import render_template, request, redirect, url_for
import json
from application.models import HealthVis
from application.forms import generate_form
from datetime import datetime, timedelta
import logging

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
    try:
        obj.put()
    except:
        return "error"
    return str(obj.key().id())

def display_accuracy_table(obj, form):
    return render_template("accuracy_table.html", obj=obj, form=form)

def display_survival(obj, form):
    return render_template("survival.html", obj=obj, form=form)

def display(id):
    obj = HealthVis.get_by_id(id)
    if obj is None:
        return render_template("500.html")

    form = generate_form(obj)

    if obj.type == "accuracyTable":
        return display_accuracy_table(obj, form)
    elif obj.type == "survival":
        return display_survival(obj, form)
    else:
        return "plot type not supported"

def save(id):
    obj = HealthVis.get_by_id(id)
    if obj is None:
        return render_template("500.html")

    obj.saved = True
    try:
        obj.put()
    except:
        return render_template("500.html")
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
    obj = HealthVis.get_by_id(id)
    if obj is None:
        return render_template("500.html")
    return obj.d3params
