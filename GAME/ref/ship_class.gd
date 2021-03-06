
extends Node

class TargetingSystem:
	var owner
	var world

	var vessel_target = 0
	var vessel_target_dock = 0
	

	var station_target = 0 setget _set_station_target
	var station_target_dock = 0 setget _set_station_target_dock

	var warpnode_target = 0
	
	func _init(owner):
		self.owner = owner
		
	func set_world():
		self.world = owner.world

	
	func next_station_target():
		var idx = self.station_target + 1
		self.set('station_target', idx)
	
	func previous_station_target():
		var idx = self.station_target - 1
		self.set('station_target', idx)
	
	func next_station_target_dock():
		var idx = self.station_target_dock + 1
		self.set('station_target_dock', idx)
	
	func previous_station_target_dock():
		var idx = self.station_target_dock - 1
		self.set('station_target_dock', idx)
	
	func _set_station_target(idx):
		var stations = world.get_stations()
		if idx > stations.size()-1:
			idx -= stations.size()
		elif idx < 0:
			idx = stations.size()-1
		station_target = idx
	
	
	func _set_station_target_dock(idx):
		var docks = get_station_target().get_docks()
		if idx > docks.size()-1:
			idx -= docks.size()
		elif idx < 0:
			idx = docks.size()-1
		station_target_dock = idx
	
	
	
	func get_station_target():
		if world:
			return world.get_stations()[station_target]
	
	func get_station_target_dock():
		var docks = get_station_target()
		if docks:
			docks = docks.get_docks()
			return docks[station_target_dock]
		

	
	
	
class PowerSystem:
	var owner
	var EPU

	var batteries = []
	
	var EXT = null	#defined when an external power source is applied
	
	var output_mode = 0
	var recharge_mode = 0
	#0: off, 1: EPU, 2: BATT1, 3: BATT2, 4: BATT1+2, 5: EXT
	
	var powered_systems = {}
	
	func _init(owner, EPU=null, batteries=[]):
		self.owner = owner
		self.EPU = EPU
		self.batteries = batteries
		
	
	


class Battery:
	var mass
	var charge
	var capacity
	
	var discharge_rate








class FuelSystem:
	var owner
	
	var tanks = []
	
	func _init(owner, tanks):
		self.owner = owner
		self.tanks = tanks

	func add_fuel_tank(contents,capacity,amount=null):
		var tank = ShipClass.FuelTank.new(self,contents,capacity,amount)
		
		self.tanks.append(tank)
	
	func remove_fuel_tank(idx):
		self.tanks.remove(idx)
	
	
	func get_pump_engaged(idx):
		assert idx < self.tanks.size()
		return self.tanks[idx].pump_engaged

	func set_pump_engaged(idx, state):
		assert idx < self.tanks.size()
		self.tanks[idx].pump_engaged = state



class FuelTank:
	var owner
	var contents
	
	var capacity
	var amount
	
	var pump_engaged = false
	
	func _init(owner,contents,capacity,amount=null):
		self.owner = owner
		self.contents = contents
		self.capacity = capacity
		self.amount = amount
		if amount == null:	# Default amount will start with a full tank
			self.amount = capacity
	
	func is_empty():
		return self.amount <= 0.0
	
	func is_full():
		return self.amount >= self.capacity
	
	func has_amount(amt):
		return amt <= self.amount
	
	func get_empty_space():
		return self.capacity-self.amount

	func drain_tank(amt):
		var value = max(amt,self.amount)
		self.amount -= value
		return value

	func fill_tank(amt):
		var value = min(amt,self.get_empty_space())
		self.amount += value
		return value



# OLD STUFF BELOW: Should be trimmed out
# sooner or later.

#############
# Vessel	#
#############
class Vessel:
	var owner
	var name
	var model
	var tag
	var ID
	var pilot
	
	var mass
	var empty_mass
	
	var pro_thrust_dv
	var retro_thrust_dv
	var rcs_dv
	
	
	var chassis
	var command
	var engine
	var reaction_control
	var power_plant
	var life_support
	var fuel_tank
	var cargo

	func _init(own,name,model,tag,ID,\
		chassis, command, engine, reaction,\
		power, support, fuel, cargo):
		
		self.own = own
		self.name = name
		self.model = model
		self.tag = tag
		self.ID = ID
		
		self.chassis = chassis
		self.command = command
		self.engine = engine
		self.reaction_control = reaction
		self.power_plant = power
		self.life_support = support
		self.fuel_tank = fuel
		self.cargo = cargo
		if chassis:		self.chassis.owner = self
		if command:		self.command.owner = self
		if engine:		self.engine.owner = self
		if reaction:	self.reaction_control.owner = self
		if power:		self.power_plant.owner = self
		if support:		self.life_support.owner = self
		if fuel:		self.fuel_tank.owner = self
		if cargo:		self.cargo.owner = self
	


#############
# Chassis	#
#############
class Chassis:
	var owner
	var name
	var ID
	
	var hull
	
	var mass
	var max_mass	#chassis determines max unladen mass
	


#################
# Command Unit	#
#################
class Command:
	var owner
	var name
	var ID
	
	var mass
	var hull
	
	var power_pull





#############
# Engine	#
#############
class Engine:
	var owner
	var name
	var ID
	
	var mass
	var hull
	
	var pro_thrust		# primary thrust power
	var retro_thrust	# retro thrust
	
	var power_pull
	




#############################
# Reaction Control System 	#
# 			(RCS)			#
#############################
class ReactionControl:
	var owner
	var name
	var ID
	
	var hull
	
	var mass
	
	var linear_thrust	# linear RCS thrust
	var angular_thrust	# angular RCS thrust
	
	var power_pull
	var fuel_pull






#################
# Power Plant	#
#################
class PowerPlant:
	var owner
	var name
	var ID
	
	var hull
	
	var mass
	
	var power_push	# power output






#################
# Life Support	#
#################
class LifeSupport:
	var owner
	var name
	var ID
	
	var hull
	
	var mass
	var power_pull
	
	var supports	# amount of life (crew) supported?






#################
# Fuel Tank		#
#################
class FuelTank:
	var owner
	var name
	var ID
	
	var hull
	var mass
	
	var max_fuel	# fuel amount when full
	var fuel		# current fuel amount




#################
# Cargo Space	#
#################
class Cargo:
	var owner
	var name
	var ID
	
	var hull
	var mass
	
	var max_bulk
	var inventory




#########################
# Hull Structure		#
#########################
class Hull:
	var owner
	
	var max_health
	var health
	var hardness




#################
# Fuel Resource	#
#################
class Fuel:
	var owner	#FuelTank or Store
	
	var mass	# mass per unit
	var bulk	# bulk per unit
	var reaction	# power output per unit



#################
# Cargo Item	#
#################
class CargoItem:
	var name
	var item	# key name of item type
	
	var bulk	# bulk per unit
	var mass	# mass per unit



#############
# Pilot		#
#############
class Pilot:
	var name
	var xp
	var credits



func MakeVessel(owner,name,model,tag,ID,\
			chassis, command, engine, reaction,\
			power, support, fuel, cargo):
	var bod = chassis
	var com = command
	var eng = engine
	var rcs = reaction
	var Pow = power
	var sup = support
	var ful = fuel
	var car = cargo
	return Vessel.new(name,model,tag,ID,\
			bod,com,eng,rcs,Pow,sup,ful,car)