from flaskext import wtf
from flaskext.wtf import validators
import json

def generate_continuous_field(values):
    return wtf.DecimalField(default=values[0], validators=[validators.NumberRange(min=values[0],max=values[1])])

def generate_factor_field(values):
    return wtf.SelectField(choices=values)

def generate_form(obj):
    var_list = json.loads(obj.var_list)
    var_names = var_list.keys()
    var_values = var_list.values()

    render_order = []

    class CovariateForm(wtf.Form):
        pass

    for i in range(len(obj.var_type)):
        if obj.var_type[i] != 'continuous':
            continue

        field = generate_continuous_field(var_values[i])
        setattr(CovariateForm, var_names[i], field)
        render_order.append(var_names[i])

    for i in range(len(obj.var_type)):
        if obj.var_type[i] != 'factor':
            continue

        field = generate_factor_field(var_values[i])
        setattr(CovariateForm, var_names[i], field)
        render_order.append(var_names[i])

    return CovariateForm(), render_order

