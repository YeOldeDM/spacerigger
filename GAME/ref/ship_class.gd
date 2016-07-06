
extends Node


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