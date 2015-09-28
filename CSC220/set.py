class Set (BasicSet):
    
# Intializes the set.
    def __init__ (self, *initialData):
        self._theElements=list(set(initialData))        
        
# Creates a new set from the intersection: self set and set B.
    def intersect (self, setB):
        assert(type(setB) is Set),"Invalid Parameter"
        tmpSet=Set()
        for i in self._theElements:
            for j in setB._theElements:
                if (i==j):
                    tmpSet.add(i)
        return tmpSet

# Creates a new set from the difference: self set and set B.
    def difference (self, setB):
        assert(type(setB) is Set),"Invalid Parameter"
        tmpSet=Set()
        for k in self._theElements:
            tmpSet.add(k)
        for i in  self._theElements:
            for j in setB._theElements:
                if j==i:
                    tmpSet.remove(i)             
        return tmpSet

# Checks if this set is a proper subset of set B.
    def isProperSubsetOf (self, setB):
        if not (type(setB) is Set):
            return False
        if ((not self.__eq__(setB)) and (self.__len__()<setB.__len__())):
            return self.isSubsetOf(setB)
        else:
            return False
    
# Returns the set as a string.
    def __str__ (self):
        tmpStr="{"
        for element in self._theElements:
            tmpStr=tmpStr+ str(element)+ ", "
        if(self.__len__()==0):
            tmpStr=tmpStr+"}"
        else:
            tmpStr=tmpStr[:-2]+"}"
        return tmpStr

# Returns an iterator for traversing the set of items.
    def __iter__ (self):
        return iter(self._theElements)
