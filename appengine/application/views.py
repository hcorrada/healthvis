from flask import render_template

def warmup():
    """App Engine warmup handler

    """
    return ''

def index():
    return render_template('index.html')
