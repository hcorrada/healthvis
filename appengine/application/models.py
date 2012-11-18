from google.appengine.ext import db

class HealthVis(db.Model):
    type = db.StringProperty(required=True)
    title = db.StringProperty(required=True)
    var_type = db.StringListProperty(required=True)
    var_list = db.StringProperty(required=True)
    data = db.StringProperty()
    saved = db.BooleanProperty(default=False)