from flask import render_template, request
import json
from application.models import HealthVis

def warmup():
    """App Engine warmup handler

    """
    return ''

def index():
    return render_template('index.html')

def post_data():
    title = request.form['title']
    type = request.form['type']
    var_list = request.form['varlist']
    var_type = json.loads(request.form['vartype'])

    obj = HealthVis(type=type,
                    title=title,
                    var_type=var_type,
                    var_list=var_list)
    obj.put()
    return str(obj.key().id())

def display_accuracy_table(obj):
    return render_template("accuracy_table.html", obj=obj)

def display(id):
    obj = HealthVis.get_by_id(id)
    if obj.type == "accuracyTable":
        return display_accuracy_table(obj)
    else:
        return "plot type not supported"

