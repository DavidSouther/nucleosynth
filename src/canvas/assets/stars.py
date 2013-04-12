#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import csv
import sys
import json
import graph
from math import sin, cos, sqrt

reader = csv.reader(sys.stdin)

class Star:
	"""Hold data about a star."""
	def __init__(self):
		self.name = "[unknown star]"
		self.spherical = {
			'ascension': 0,
			'declination': 0,
			'distance': 0
		}
		self.rectilinear = {
			'x': 0,
			'y': 0,
			'z': 0
		}

	def __str__(self):
		return "Star " + self.name + " at " + str(self.rectilinear) + "."

	def findPosition(self):
		a = self.spherical['ascension']
		d = self.spherical['declination']
		D = self.spherical['distance']
		self.rectilinear = {
			'x': D * cos(a) * cos(d),
			'y': D * sin(a) * cos(d),
			'z': D * sin(d)
		}

	def forJSON(self):
		return {"position": self.rectilinear, "spectral": self.spectral}

	def distance(self, star):
		x, y, z = [
			(self.rectilinear['x'] - star.rectilinear['x']),
			(self.rectilinear['y'] - star.rectilinear['y']),
			(self.rectilinear['z'] - star.rectilinear['z'])
		]
		return x*x + y*y + z*z

	@staticmethod
	def fromWiki(line):
		star = Star()
		star.name = line[2]
		star.spectral = line[4]
		star.spherical = {
			'ascension': parseDMS(line[-4]),
			'declination': parseHMS(line[-5]),
			'distance': float(line[1])
		}
		star.findPosition()
		return star

def parseDMS(dms):
	d, ms = dms.split('d')
	m, s = ms.split('m')
	s = s[0:2]
	return float(d) + (float(m)/60) + (float(s) / 3600)

def parseHMS(hms):
	h, ms = hms.split('h')
	m, s = ms.split('m')
	s = ms[0:2]
	return float(h) + (float(m)/60) + (float(s) / 3600)

def main():
	stars = {}
	for entry in reader:
		star = Star.fromWiki(entry)
		stars[star.name] = star
	wormholes = graph.walk(stars)
	for n, s in stars.iteritems():
		stars[n] = s.forJSON()
	print "Stars = " + json.dumps(stars)
	print "Wormholes = " + json.dumps(wormholes)

if __name__ == "__main__":
	main()