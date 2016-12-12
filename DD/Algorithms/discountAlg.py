import rideController as rC
import carController  as cC

def check_discount(ride):
	# Number of passengers at each acquisition 
	passengers_num = []
	# Number of good acquisition (more than 2 
	# passenger, diver included)	
	good_acquisitions = 0
	# The car object is save in the ride 
	# argument passed to check_discount()
	ride_car = rC.getcar(ride)		
	# The ride status is updated by the car 
	# it self so reading it from the ride element
	# is safe to assume correct
	ride_status = rC.getStatus(ride)
	
	while(ride_status == rC.status.IN_USE):
		passengers_num.append(cC.getPassengers(ride_car))
		sleep(20) 	# sleeps 20 seconds
		ride_status = rC.getStatus(ride)
	
	for acquisition in passengers_num:
		if acqusition > 2 :
			good_acquisitions += 1
	
	# More than 2 passenger must be present for 
	# more than 60% of acquisition
	if(len(passengers_num) * 0.6 >= good_acquisitions):  
		return False
	else:
		return True