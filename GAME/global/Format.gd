
extends Node

const MONTHS = {
	-1:	["", 0],
	0:	["JAN",	31],
	1:	["FEB",	59],
	2:	["MAR",	90],
	3:	["APR",	120],
	4:	["MAY",	151],
	5:	["JUN",	181],
	6:	["JUL",	212],
	7:	["AUG",	243],
	8:	["SEP",	273],
	9:	["OCT",	304],
	10:	["NOV",	334],
	11:	["DEC",	365]
	}


func date(T):
	var year = (T / 31556926) + 1970
	var days = ((T / 86400) % 364) + 1	#days into the year
	var month = 0
	while MONTHS[month][1] < days:
		month += 1
	var day = days - MONTHS[month-1][1]
	return MONTHS[month][0] +" "+ str(day) +", "+ str(year)
	
	
	#return MONTHS[month][0]+" "+str(day)+", "+str(year)

	
func time(T):
	T = int(T)
	var hours = (T / 3600) % 24
	var minutes = (T / 60) % 60
	var seconds = T % 60
	
	var H = str(hours)
	var M = str(minutes)
	var S = str(seconds)
	var T = [H,M,S]
	for i in range(T.size()):
		if T[i].length() == 1:
			T[i] = "0"+T[i]

	
	return T[0]+" : "+T[1]+" : "+T[2]


func dict2time(D):
	var hr = str(D['hour'])
	var mn = str(D['minute'])
	var sc = str(D['second'])
	return hr+":"+mn+":"+sc

func dict2date(D):
	var month = str(D['month'])
	var day = str(D['day'])
	var year = str(D['year'])
	return month+'/'+day+'/'+year
