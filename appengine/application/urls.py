from application import app
from application import views

# App Engine warm up handler
app.add_url_rule('/_ah/warmup', 'warmup', view_func=views.warmup)

# index page
app.add_url_rule('/', 'index', view_func=views.index)
