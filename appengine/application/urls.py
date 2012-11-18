from application import app
from application import views

# App Engine warm up handler
app.add_url_rule('/_ah/warmup', 'warmup', view_func=views.warmup)

# index page
app.add_url_rule('/', 'index', view_func=views.index)

# generate a uuid
app.add_url_rule('/post_data', 'post_data', view_func=views.post_data, methods=['POST'])

# display plot
app.add_url_rule('/display/<int:id>', 'display', view_func=views.display)

# save plot
app.add_url_rule('/save/<int:id>', 'save', view_func=views.save)
