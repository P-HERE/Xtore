from libcpp.vector cimport vector
from libcpp.string cimport string
from libc.stdint cimport uint8_t

cdef extern from "xtorecpp/HomomorphicEncryption.hpp" namespace "Xtore":

    cdef cppclass Ciphertext:
        pass
    cdef cppclass Plaintext:
        pass
    cdef cppclass DCRTPoly:
        pass
    cdef cppclass CryptoContext:
        pass
        
    cdef cppclass HomomorphicEncryption:
        HomomorphicEncryption()
        void initializeCKKS(int multiplicativeDepth, int scalingModSize, int firstModSize, int ringDim, int batchSize)
        void generateRotateKey(int slots)
        void setupSchemeSwitching(int slots, int logQ_ccLWE)
        Ciphertext encrypt(const vector[double]& plain) except +
        Plaintext decrypt(Ciphertext ciphertext) except +
        vector[double] compare(int slots, Ciphertext cipher1, Ciphertext cipher2) except +
        Ciphertext sumCiphertext(int slots, Ciphertext ciphertext) except +
        Ciphertext maskCiphertext(int slots, Ciphertext ciphertext, Ciphertext mask) except +
        vector[double] getRealValue(int slots, Ciphertext maskCiphertext) except +
        void writeCiphertextToFile(const string& filepath, Ciphertext ciphertext) except +
        Ciphertext extractSlot(int slots, int index, Ciphertext ciphertext) except +
        Ciphertext rotateCipher(int index, Ciphertext ciphertext) except +
        vector[uint8_t] serialize(Ciphertext ciphertext) except +
        Ciphertext deserialize(vector[uint8_t] ciphertext) except +

cdef class CythonHomomorphic:
    cdef HomomorphicEncryption* homomorphic
    cdef initializeCKKS(self, int multiplicativeDepth, int scalingModSize, int firstModSize, int ringDim, int batchSize)
    cdef generateRotateKey(self, int slots)
    cdef setupSchemeSwitching(self, int slots, int logQ_ccLWE)
    cdef Ciphertext encrypt(self, vector[double] plaintext)
    cdef Plaintext decrypt(self, Ciphertext ciphertext)
    cdef vector[double] compare(self, int slots, Ciphertext ciphertext1, Ciphertext ciphertext2)
    cdef Ciphertext sumCiphertext(self, int slots, Ciphertext ciphertext)
    cdef Ciphertext maskCiphertext(self, int slots, Ciphertext ciphertext, Ciphertext mask)
    cdef vector[double] getRealValue(self, int slots, Ciphertext maskCiphertext)
    cdef writeCiphertextToFile(self, str filepath, Ciphertext ciphertext)
    cdef Ciphertext extractSlot(self, int slots, int index, Ciphertext ciphertext)
    cdef Ciphertext rotateCipher(self, int index, Ciphertext ciphertext)
    cdef vector[uint8_t] serialize(self, Ciphertext ciphertext)
    cdef Ciphertext deserialize(self, vector[uint8_t] ciphertext)