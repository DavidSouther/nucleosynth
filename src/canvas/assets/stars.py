#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import csv
import sys
from math import sin, cos

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
		return "Star " + self.name + " at " + self.position() + "."

	def findPosition(self):
		a = self.spherical['ascension']
		d = self.spherical['declination']
		D = self.spherical['distance']
		self.rectilinear = {
			'x': D * cos(a) * cos(d),
			'y': D * sin(a) * cos(d),
			'z': D * sin(d)
		}

	def position(self):
		# return str(self.spherical['ascension']) + " ra " + str(self.spherical['declination']) + " d " + str(self.spherical['distance']) + " ly"
		self.findPosition()
		return "(" + str(self.rectilinear['x']) + ", " + str(self.rectilinear['y']) + ", " + str(self.rectilinear['z']) + ")"

	@staticmethod
	def fromWiki(line):
		star = Star()
		star.name = line[2]
		star.spherical = {
			'ascension': parseDMS(line[-4]),
			'declination': parseHMS(line[-5]),
			'distance': float(line[1])
		}
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
	for entry in reader:
		print entry
		star = Star.fromWiki(entry)
		print star

if __name__ == "__main__":
	main()