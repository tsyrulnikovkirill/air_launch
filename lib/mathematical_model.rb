require_relative 'constants'
require_relative 'atmosphere_parameters'

#вспомогательные уравнения
def mah(velocity, height)
  velocity / AtmosphereParameters.new(height).parameter_sound_velocity
end

def current_mass(t)
  MASS_0 - D_MASS_DT * t
end

def approximation_cxa(mah)
  0.1
end

def thrust # ускорение св пад для удельного импульса берется на нулевой высоте
  D_MASS_DT * SPEC_THRUST * AtmosphereParameters.new(0).parameter_acceleration_free_fall
end

def force_xa(velocity, height)
  S_M * AtmosphereParameters.new(height).parameter_density * velocity *
    velocity / 2 * approximation_cxa(mah(velocity, height))
end

#законы управления

# Производная скорости ЛА
def dv_dt(velocity, height, tetta, t)
  x_a = force_xa(velocity, height)
  acceleration = AtmosphereParameters.new(height).parameter_acceleration_free_fall

  (thrust - x_a) / current_mass(t) - acceleration * tetta
end

# Производная угла наклона траектории
def d_tetta_dt(velocity, height, tetta)
  -AtmosphereParameters.new(height).parameter_acceleration_free_fall * Math.cos(tetta) / velocity
end

def dx_dt(velocity, tetta)
  velocity * Math.cos(tetta)
end

def dy_dt(velocity, tetta)
  velocity * Math.sin(tetta)
end

def issue_parameters(n, t, v, y, x, tetta)
  [n, t, v, y , x.round(6), current_mass(t), degrees(tetta), tetta]
end
