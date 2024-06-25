class user_info {
	static info_map := Map(
		'your name', your_name := 'blank',
		'your initials', your_initials := '',
		'your title', your_title := '',
		'work email', work_email := '@fmglobal.com',
		'pers email', personal_email := '',
		'employee id', employee_number := '',
		'office phone', office_phone := '',
		'pers address', personal_address := '',
		'manager name', manager_name := '',
		'manager title', manager_title := '',
		'manager email', manager_email := '',
	)
	static info_arr := Array(
		your_name := 'blank',
		your_initials := '',
		your_title := '',
		work_email := '@fmglobal.com',
		personal_email := '',
		employee_number := '',
		office_phone := '',
		personal_address := '',
		manager_name := '',
		manager_title := '',
		manager_email := '',
	)
	static office_map := Map(
		'office', office := 'FM Global Office: ',
	)
	
	static office_address_map := Map(
		'office address', office_address := 'FM Global: ',
	)

	static office_location_array := Array(
		'Walnut Creek',
		'Seattle',
		'Portland'
	)
	static array_office_name := ['Walnut Creek', 'Seattle', 'Portland']

	static office_total_map := Map(
		'office name', office_name := '',
		'office address', office_address := '',
		'office city', office_city := '',
		'office state', office_state := '',
		'office zip', office_zip := 0
		'office phone', office_phone := 0 ;fix this is a placeholder and needs to be a format wrapper around the variable, e.g., formate(office_phone := 000-000-0000)
		'office pr email', office_pr_email := 'pr@fmglobal.com'
	)
}