from xtore.BaseType cimport i32
from xtore.algorithm.PrimeRing cimport PrimeRing
from xtore.instance.RecordNode cimport hashDJB
from xtore.algorithm.PrimeNode cimport PrimeNode
from xtore.algorithm.StorageUnit cimport StorageUnit, Mode

from libc.stdlib cimport malloc
from libc.string cimport memcpy
from cpython cimport PyBytes_FromStringAndSize
from argparse import RawTextHelpFormatter
import os, sys, argparse, json

cdef str __help__ = ""
cdef bint IS_VENV = sys.prefix != sys.base_prefix
cdef i32 BUFFER_SIZE = 1 << 16

def run():
	cdef InitPrimeRingCLI service = InitPrimeRingCLI()
	service.run(sys.argv[1:])

cdef class InitPrimeRingCLI:
	cdef object parser
	cdef object option
	cdef dict config

	cdef getParser(self, list argv):
		self.parser = argparse.ArgumentParser(description=__help__, formatter_class=RawTextHelpFormatter)
		self.parser.add_argument("-s", "--method", help="Select Method", required=True, choices=['Get', 'Set'])
		self.parser.add_argument("-k", "--key", help="Type Key", required=True)
		self.option = self.parser.parse_args(argv)
	
	cdef run(self, list argv):
		self.getParser(argv)
		self.getConfig()
		cdef PrimeRing ring
		ring = PrimeRing()
		ring.loadData(self.config["nodeList"])
		cdef StorageUnit storageUnit
		print(ring)
		hashKey = hashDJB(self.option.key.encode(), 5)
		storageUnit = ring.getStorageUnit(hashKey)
		print(storageUnit)
		for i in range(16):
			storageUnit.getNextNode(mode = Mode.AdHoc)

	cdef getConfig(self):
		cdef str configPath = os.path.join(sys.prefix, "etc", "xtore", "XtoreNetwork.json")
		cdef object fd
		with open(configPath, "rt") as fd :
			self.config = json.loads(fd.read())


