class Date :
# Creates an object instance for the specified Gregorian date.
    def __init__( self, month, day, year ):               
        self._julianDay = 0
        assert self._isValidGregorian( month, day, year ), \
           "Invalid Gregorian date."
           
# The first line of the equation, T = (M - 14) / 12, has to be changed 
# since Python's implementation of integer division is not the same
# as the mathematical definition.
        tmp = 0                          
        if month < 3 :
            tmp = -1                       
        self._julianDay = day - 32075 + \
             (1461 * (year + 4800 + tmp) // 4) + \
             (367 * (month - 2 - tmp * 12) // 12) - \
             (3 * ((year + 4900 + tmp) // 100) // 4)    
             
# Extracts the appropriate Gregorian date component.             
    def month( self ):                                               
        return (self._toGregorian())[0]  # returning M from (M, d, y)
    
    def day( self ):
        return (self._toGregorian())[1]  # returning D from (m, D, y)
    
    def year( self ):
        return (self._toGregorian())[2]  # returning Y from (m, d, Y)  

# Returns day of the week as an int between 0 (Mon) and 6 (Sun).
    def dayOfWeek( self ):                                     
        month, day, year = self._toGregorian()
        if month < 3 : 
            month = month + 12
            year = year - 1      
        return ((13 * month + 3) // 5 + day + \
            year + year // 4 - year // 100 + year // 400) % 7  
           
# Returns the date as a string in Gregorian format.           
    def __str__( self ):                           
        month, day, year = self._toGregorian()
        return "%02d/%02d/%04d" % (month, day, year)  
  
# Logically compares the two dates.
    def __eq__( self, otherDate ):                     
        return self._julianDay == otherDate._julianDay

    def __lt__( self, otherDate ):
        return self._julianDay < otherDate._julianDay
    
    def __le__( self, otherDate ):
        return self._julianDay <= otherDate._julianDay   
        
# The remaining methods are to be included at this point.
# ......

# Returns the Gregorian month name of this date.
    def monthName(self):
        monthNameList=['January','February','March','April','May','June',\
                   'July','August','September','October','November',\
                   'December']
        return monthNameList[self.month()-1]
    
# Returns the number of days as a positive integer between this date 
# and the other date.
    def numDays(self,otherDate):
        count=0
        tmpDate = Date (1,1,1)
        tmpDate._julianDay=self._julianDay
        while (not tmpDate.__eq__(otherDate)):
            if (tmpDate.__lt__(otherDate)):
                count=count+1
                tmpDate._julianDay=tmpDate._julianDay+1
            else:
                count=count+1
                tmpDate._julianDay=tmpDate._julianDay-1 
        return count   
    
# Private method for testing if julian year value is a valid gregorian year.
# Used in _isValidGregorian method.
    def _isLeapYearJulian(self,year):
        
        cond1=False # If date divisible by 4
        cond2=False # If date divisible by 400
        cond3=False # If date divisible by 100
        
        if (year%4==0):
            cond1=True
            cond3=True
        else:
            cond1=False
        if(year%100==0):
                if(year%400==0):
                    cond2=True
                    cond3=False
                else:
                    cond2=False
        else:
            cond2=False
            cond3=False
        return ((cond1 and not cond3) or cond2)
    
# Determines if this date falls in a leap year and returns 
# the appropriate boolean value.    
    def isLeapYear(self):
        return(self.year()%4==0)
    
# Advances the date by the given number of days. The date is incremented
# if days is positive and decremented if date is negative.
    def advanceBy(self, days):
        self._julianDay=self._julianDay+days
        
# Compares this date with otherDate to determine their logical ordering.
    def comparable(self,otherDate):
        if self.__eq__(otherDate):
            return 0
        elif self.__lt__(otherDate):
            return -1
        else:
            return 1
            
# Checks if input month, day, year values will produce a valid date object.
# Checks if month is between 1-12, and if days range from 1-28,29,30 or 31,
# depending on month.

    def _isValidGregorian(self,month,day,year):
        julianLeapBool=(self._isLeapYearJulian(year))
        dateRange=False 
        if(month>0 and month<13):
            if month==1:
                if (day>0 and day<32):
                    dateRange=True
                else:
                    dateRange=False
            elif month==2:
                if julianLeapBool:
                    if (day>0 and day<30):
                        dateRange=True
                    else:
                        dateRange=False
                else:
                    if (day>0 and day<29):
                        dateRange=True
                    else:
                        dateRange=False
            elif(month>2 and month<8):
                if(month%2==0):
                    if(day>0 and day<31):
                        dateRange=True
                    else:
                        dateRange=False
                else:
                    if(day>0 and day<32):
                        dateRange=True
                    else:
                        dateRange=False
            else:
                if(month%2==0):
                    if(day>0 and day<32):
                        dateRange=True
                    else:
                        dateRange=False
                else:
                    if(day>0 and day<31):
                        dateRange=True
                    else:
                        dateRange=False
        else:
            dateRange=False
        return dateRange
    
# Returns the Gregorian date as a tuple: (month, day, year).
    def _toGregorian( self ):           
        A = self._julianDay + 68569
        B = 4 * A // 146097
        A = A - (146097 * B + 3) // 4
        year = 4000 * (A + 1) // 1461001
        A = A - (1461 * year // 4) + 31
        month = 80 * A // 2447
        day = A - (2447 * month // 80)  
        A = month // 11
        month = month + 2 - (12 * A)
        year = 100 * (B - 49) + year + A
        return month, day, year
