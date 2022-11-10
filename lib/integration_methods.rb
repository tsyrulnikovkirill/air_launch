require_relative 'mathematical_model'
require_relative 'constants'
require_relative 'excel_data'

def method_runge_kutta(dt)
  excel = ExcelData.new("Р-К с ш. #{dt}")

  t = 0
  v_old = V_0
  v_new = V_0
  tetta_old = TETTA_0
  tetta_new = TETTA_0
  x_old = X_0
  x_new = X_0
  y_old = Y_0
  y_new = Y_0
  n = 0

  parameters = issue_parameters(n, t, v_new, y_new, x_new, tetta_new)
  excel.create_line(parameters)

  while t <= T_K
    k_v_1 = dt * dv_dt(v_old, y_old, tetta_old, t)
    k_tetta_1 = dt * d_tetta_dt(v_old, y_old, tetta_old)
    k_x_1 = dt * dx_dt(v_old, tetta_old)
    k_y_1 = dt * dy_dt(v_old, tetta_old)

    k_v_2 = dt * dv_dt(v_old + k_v_1 / 2, y_old + k_y_1 / 2, tetta_old + k_tetta_1 / 2, t + dt / 2)
    k_tetta_2 = dt * d_tetta_dt(v_old + k_v_1 / 2, y_old + k_y_1 / 2, tetta_old + k_tetta_1 / 2)
    k_x_2 = dt * dx_dt(v_old + k_v_1 / 2, tetta_old + k_tetta_1 / 2)
    k_y_2 = dt * dy_dt(v_old + k_v_1 / 2, tetta_old + k_tetta_1 / 2)

    k_v_3 = dt * dv_dt(v_old + k_v_2 / 2, y_old + k_y_2 / 2, tetta_old + k_tetta_2 / 2, t + dt / 2)
    k_tetta_3 = dt * d_tetta_dt(v_old + k_v_2 / 2, y_old + k_y_2 / 2, tetta_old + k_tetta_2 / 2)
    k_x_3 = dt * dx_dt(v_old + k_v_2 / 2, tetta_old + k_tetta_2 / 2)
    k_y_3 = dt * dy_dt(v_old + k_v_2 / 2, tetta_old + k_tetta_2 / 2)

    k_v_4 = dt * dv_dt(v_old + k_v_3, y_old + k_y_3, tetta_old + k_tetta_3, t + dt)
    k_tetta_4 = dt * d_tetta_dt(v_old + k_v_3, y_old + k_y_3, tetta_old + k_tetta_3)
    k_x_4 = dt * dx_dt(v_old + k_v_3, tetta_old + k_tetta_3)
    k_y_4 = dt * dy_dt(v_old + k_v_3, tetta_old + k_tetta_3)

    v_new = v_old + (k_v_1 + 2 * k_v_2 + 2 * k_v_3 + k_v_4) / 6
    tetta_new = tetta_old + (k_tetta_1 + 2 * k_tetta_2 + 2 * k_tetta_3 + k_tetta_4) / 6
    x_new = x_old + (k_x_1 + 2 * k_x_2 + 2 * k_x_3 + k_x_4) / 6
    y_new = y_old + (k_y_1 + 2 * k_y_2 + 2 * k_y_3 + k_y_4) / 6

    v_old = v_new
    tetta_old = tetta_new
    x_old = x_new
    y_old = y_new

    t += dt
    t = t.round(3)

    k = t.to_s.split('.').first.to_i

    if k / t == 1
      n += 1
      parameters = issue_parameters(n, t, v_new, y_new, x_new, tetta_new)
      excel.create_line(parameters)
    end
  end

  excel.create_sheet
  excel.save
end

