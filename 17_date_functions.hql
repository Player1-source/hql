SELECT current_date,
date_add(current_date, 7),
add_months(current_date, 1),
trunc(current_date, 'MM');