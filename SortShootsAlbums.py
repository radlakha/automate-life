################################################################################
## Sorting out my shoot folders
## Problem description:
## I have my shoots and processed outcomes in the same folder.
## Sometimes the folder has RAW as well Camera JPEGs.
## I would like to separate the RAW and JPEGS into separate parallel folder trees
## - one for Shoots and other for Albums
## because I have different backup and sharing strategy for both
## Also, because I have realized that there isn't going to be a simple one-to-one
## mapping between Shoots and Albums (many Shoots can contribute to one Album)

# Tab size equals 4 spaces
# if you are having to tab three times you need a function

## Backlog (move these as JIRAs and clear out from here)
## Shit happens - Add Error handling everywhere
## Build fences - write defencive code
## Commandline interface - build cool CLI using CLI module

import sys
import os
import shutil

# initialize global flags and settings
YearFolder = DestYearShootFolder = DestYearAlbumFolder = Commit = ''
ShootFoldersWorked = FilesWorked = 0
RAWFileCount = ProcessedFileCount = 0


def aDir(DirPath):
	if not os.path.isdir(DirPath): 
		return(0)
	return(1)

def ProcessShootFolder(PathtoShootFolder):
	print ('\tProcessing:' + os.path.basename(PathtoShootFolder)) 
	
	global ShootFoldersWorked, FilesWorked, DestYearShootFolder, Commit, RAWFileCount, ProcessedFileCount

	RAWFiles = []
	ProcessedFiles = []
	IgnoredFiles = []
	
	RawImageFileSuffixExtn = (".arw", ".ARW", ".mts", ".MTS", ".mp4", ".MP4", ".mpg", ".MPG")
	ProcessedImageFileSuffixExtn = (".jpg", ".JPG", ".jpeg", ".JPEG", ".tiff", ".TIFF")

	ShootFoldersWorked = ShootFoldersWorked + 1
	
	#Create DestShootFolder in DestYearShootFolder
	DestShootFolder = os.path.join(DestYearShootFolder, os.path.basename(PathtoShootFolder)) + ' SRTD'
	print('\tDestination Shoot Folder', DestShootFolder)
	if Commit == 'Commit': 
		if not aDir(DestShootFolder): os.makedirs(DestShootFolder)
	
	#Create DestAlbumFolder in DestYearAlbumFolder
	DestAlbumFolder = os.path.join(DestYearAlbumFolder, os.path.basename(PathtoShootFolder))
	print('\tDestination Album Folder', DestAlbumFolder)
	#print()
	if Commit == 'Commit': 
		if not aDir(DestAlbumFolder): os.makedirs(DestAlbumFolder)
	
	for (root,dirs,files) in os.walk(PathtoShootFolder, topdown=1): 
		#separate raw and processed files in the folder
		for eachFile in files:
			FilesWorked = FilesWorked + 1
			#Read all RAW filenames in ShootFolder into a RAWFiles list #look in subfolders too
			#Read all JPEGS and TIFF filenames in ShootFolder into a ProcessedFiles list #look in subfolders too
			if eachFile.endswith(RawImageFileSuffixExtn): 
				RAWFileCount += 1
				RAWFiles.append(os.path.join(root, eachFile))
			elif eachFile.endswith(ProcessedImageFileSuffixExtn): 
				ProcessedFileCount += 1
				ProcessedFiles.append(os.path.join(root, eachFile))
			else:
				IgnoredFiles.append(os.path.join(root, eachFile))
		
	#Copy all files in ProcessedFiles list to DestYearAlbumFolder
	if (len(ProcessedFiles) > 0):
		for file in ProcessedFiles:
			destFile = os.path.join(DestAlbumFolder, os.path.basename(file))
			print('\t\tCopying %s - %s' % (file, destFile))
			if Commit == 'Commit': shutil.copy(file, destFile)
	else:
		print('\t\tNo processed files here')
	
	#Copy all files in ProcessedFiles list to DestShootFolder only if no RAWFiles found
	#For in early days I shot in JPEG
	if (len(RAWFiles) == 0) :
		for file in ProcessedFiles:
			destFile = os.path.join(DestShootFolder, os.path.basename(file))
			print('\t\tCopying %s - %s' % (file, destFile))
			if Commit == 'Commit': shutil.copy(file, destFile)
	else:
		for file in RAWFiles:
			destFile = os.path.join(DestShootFolder, os.path.basename(file))
			print('\t\tCopying %s - %s' % (file, destFile))
			if Commit == 'Commit': shutil.copy(file, destFile)

	#List Ignored files for info
	if (len(IgnoredFiles) > 0):
		for file in IgnoredFiles:
			print('\t\tIgnored %s' % (file))
	else:
		print('\t\tNo Ignored files here')
	
	
	
def Init():

	global YearFolder
	global DestYearShootFolder 
	global DestYearAlbumFolder 
	global Commit
	
	# Must upgrade code using CLI import
	if len(sys.argv) < 5:
		print (os.getcwd())
		print ("Give me a dir path where your shoot folders are stored and the destination folders for Shoots and Albums. Please.")
		print ("SortShootsAlbums YearFolder DestYearShootFolder DestYearAlbumFolder Commit/Dunzo")
		exit(0)
	else:
		YearFolder = sys.argv[1]
		DestYearShootFolder = sys.argv[2]
		DestYearAlbumFolder = sys.argv[3]
		Commit = sys.argv[4]

	# Hey check if the passed argument is indeed a folder name!
	if not aDir(YearFolder):
		print("Check the path name provided to where your shoot folders are stored.")
		exit(0)
	print('Scanning Shoots in: ', YearFolder)

	if not aDir(DestYearShootFolder): os.makedirs(DestYearShootFolder)
	if not aDir(DestYearAlbumFolder): os.makedirs(DestYearAlbumFolder)
	

	
def Start() :

	for ShootFolder in os.listdir(YearFolder):
		PathtoShootFolder = os.path.join(YearFolder, ShootFolder)
		if aDir(PathtoShootFolder):
			ProcessShootFolder(PathtoShootFolder) #separate the raw files from processed files
		else:
			print("\tSkipping File in top level shoots folder - %s" % (os.path.basename(PathtoShootFolder)))

	return (1)

def Finish():
	print('O human, my creator, you made me in 4 hours and 33 minutes.')
	print('In return I worked %s Files in %s Folders you created in the year %s ' % (FilesWorked, ShootFoldersWorked, YearFolder))
	print('saving you approximately %s hours and %s minutes.' % (ShootFoldersWorked*3//60, ShootFoldersWorked*3%60))
	print('How many days you would have sat at your desk to complete this?')
	print('I noticed you had %s RAW files and %s JPEGs' % (RAWFileCount, ProcessedFileCount))
	return(1)
	
def CleanUp():
	#Clean up after you
	return()
	
Init()
Start()
Finish()
CleanUp()