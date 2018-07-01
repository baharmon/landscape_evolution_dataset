test -r ~/.alias && . ~/.alias
PS1='GRASS 7.3.svn (nc_spm_evolution):\w > '
grass_prompt() {
	LOCATION="`g.gisenv get=GISDBASE,LOCATION_NAME,MAPSET separator='/'`"
	if test -d "$LOCATION/grid3/G3D_MASK" && test -f "$LOCATION/cell/MASK" ; then
		echo [2D and 3D raster MASKs present]
	elif test -f "$LOCATION/cell/MASK" ; then
		echo [Raster MASK present]
	elif test -d "$LOCATION/grid3/G3D_MASK" ; then
		echo [3D raster MASK present]
	fi
}
PROMPT_COMMAND=grass_prompt
export PATH="/Applications/GRASS-7.3.app/Contents/MacOS/bin:/Applications/GRASS-7.3.app/Contents/MacOS/scripts:/Users/Brendan/Library/GRASS/7.3/Modules/bin:/Users/Brendan/Library/GRASS/7.3/Modules/scripts:/Users/Brendan/Grass Data/WebPublishing2/r.out.leaflet-master/r.out.leaflet:/Users/Brendan/landscape_evolution:/Volumes/grey/fort_bragg/code:/Users/Brendan/Grass Data/WebPublishing2/r.out.leaflet-master/r.out.leaflet:/Users/Brendan/landscape_evolution:/Volumes/grey/fort_bragg/code:/Users/Brendan/Grass Data/WebPublishing2/r.out.leaflet-master/r.out.leaflet:/Users/Brendan/landscape_evolution:/Volumes/grey/fort_bragg/code:-framework GDAL/Library/Frameworks/PROJ.framework/Programs:/usr/bin:/usr/local/Cellar/python/2.7.11/bin:/Users/Brendan/anaconda/bin:/Library/Frameworks/Python.framework/Versions/2.7/bin:/usr/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/opt/keckcaves/bin:/usr/local/git/bin:/Library/TeX/texbin"
export HOME="/Users/Brendan"
