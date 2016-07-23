
extends Node

# convert timestamp to human-readable hh:mm:ss
func date(T):
	var year = (T / 31556926) + 1970
	var month = ((T / 2629743) % 12) + 1
	var day = ((T / 86400) % 365) % 30
	return str(month)+"/"+str(day)+"/"+str(year)
	
func time(T):
	var hours = (T / (60*60)) % 24
	var minutes = (T / 60) % 60
	var seconds = T % 60
	
	var H = str(hours)
	var M = str(minutes)
	var S = str(seconds)
	var T = [H,M,S]
	for i in range(T.size()-1):
		if T[i].length() == 1:
			T[i] = "0"+T[i]

	
	return T[0]+":"+T[1]+":"+T[2]



