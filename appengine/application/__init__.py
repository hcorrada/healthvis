from flask import Flask
from flaskext.gae_mini_profiler import GAEMiniProfiler

app = Flask('application')
app.config.from_object('application.settings')

# enable profiler
GAEMiniProfiler(app)

# Pull in URL dispatch routs
import urls

