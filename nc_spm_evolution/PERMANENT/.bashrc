test -r ~/.alias && . ~/.alias
PS1='GRASS 7.4.1svn (nc_spm_evolution):\w > '
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
export PATH="/usr/local/grass-7.4.1svn/bin:/usr/local/grass-7.4.1svn/scripts:/home/baharmon/.grass7/addons/bin:/home/baharmon/.grass7/addons/scripts:/home/baharmon/landscape_evolution/testing:/home/baharmon/panama_hydrological_modeling/utilities:/home/baharmon/landscape_evolution:/home/baharmon/landscape_evolution/testing:/home/baharmon/panama_hydrological_modeling/utilities:/home/baharmon/landscape_evolution:/home/baharmon/landscape_evolution/testing:/home/baharmon/panama_hydrological_modeling/utilities:/home/baharmon/landscape_evolution:/home/baharmon/bin:/home/baharmon/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/local/:/snap/bin"
export HOME="/home/baharmon"
