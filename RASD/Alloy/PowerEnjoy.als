open util/integer as integer

//---SIGNATURES---

abstract sig Boolean {}
one sig True extends Boolean {}
one sig False extends Boolean {}

one sig PowerEnjoy {
	registeredUsers : set User,
	cars : some Car,
	safeAreas: some SafeArea,
	chargingStations : some ChargingStation 
}

abstract sig UserStatus{}
sig Active, Suspended extends  UserStatus{}

sig User{
	status: one UserStatus,
	currentRide : lone Ride,
	ridesHistory : set Ride,	
}{
	status = Suspended implies currentRide = none
}

abstract sig CarStatus{}
sig Closed, OpenLocked, OpenUnlocked extends CarStatus{}

sig Car{
	status : one CarStatus,
	passengers : one Int,
	available : one Boolean,
	position: one Position,
	safeArea : one SafeArea,
    battery : one Int
}
{
	passengers >= 0 and passengers <= 5
	(status= OpenLocked or status = OpenUnlocked) implies available = False
	battery >=0 and battery<=10
	passengers != none implies status = Closed
	battery = 0 implies available = False
}

sig Position{
	latitude : one Int,
	longitude : one Int
}

sig SafeArea{
	area : some Position,
}{
	#(area)>2
}

sig ChargingStation{
	position : one Position,
	maxPlugs : one Int,
	availablePlugs : one Int,
	carsConnected : set Car
}{
	maxPlugs >= 0
	availablePlugs >= 0
	maxPlugs >= availablePlugs + #(carsConnected)
}

sig Ride{
	status : one RideStatus,
	car : one Car,
	reservationMinutes : one Int,
	rideMinutes : one Int,
	billAmount : one Int, //int?
	billStatus : one BillStatus
}{
	billAmount >= 0
	reservationMinutes >= 0
	rideMinutes >= 0
}

abstract sig BillStatus {}
sig Paid, Pending, Rejected extends BillStatus{}

abstract sig RideStatus{}
sig reservation, InUse, Finished extends RideStatus{}

//---FACTS---

fact{
	no disjoint x, y : User | x.currentRide = y.currentRide
}

fact {
	all u: User | lone r:Ride | (r in u.ridesHistory and r.billStatus != Paid)
}

fact{
	all u : User | u in PowerEnjoy.registeredUsers
}
fact{
	all us : UserStatus | us in User.status
}
fact{
	all c : Car | c in PowerEnjoy.cars
}
fact {
	all sa : SafeArea | sa in PowerEnjoy.safeAreas
}

fact{
	all cs : ChargingStation | cs in PowerEnjoy.chargingStations
}

fact {
	no disjoint p1,p2 : Position| p1.latitude=p2.latitude and p1.longitude=p2.longitude
}

fact{
no disjoint sa1, sa2: SafeArea,  p: Position| p in sa1.area and p in sa2.area
}

fact{
no disjoint cs1, cs2: ChargingStation,  p: Position| p=cs1.position and p=cs2.position
}

fact{
all p: Position | (p in SafeArea.area or p in Car.position or p = ChargingStation.position)
}

fact{
	all rs : RideStatus | rs in Ride.status
}

fact{
	all bs : BillStatus | bs in Ride.billStatus
}
fact{
	all cs : CarStatus | cs in Car.status
}


fact{
	no disjoint x, y : Ride | x.car = y.car
}


//---PRED---

pred show(){
#(User)>2

}

run show for 4 but 7 Int


