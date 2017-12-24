g.copy
g.copy.all
g.copyall
g.copyall mapset=patterson_branch
g.copyall mapset=patterson_branch datatype=vect
g.copyall mapset=patterson_branch datatype=region
g.copy raster=fortbragg_9m_2012@reference_data,fortbragg_elevation_9m_2012
g.copy raster=fortbragg_shaded_9m_2012@reference_data,fortbragg_shaded_9m_2012
g.region region=region res=0.3
r.slope.aspect
r.slope.aspect elevation=elevation_2012@PERMANENT aspect=aspect_2012
g.remove
g.remove -f type=raster name=aspect_2012@PERMANENT
r.profile
r.profile -g input=difference_2012_2016@PERMANENT output=profile.txt coordinates=597401.913183,150866.495177,597261.559486,151011.913183
v.in.ascii input=profile.txt output=profile separator=space columns=x DOUBLE, y DOUBLE, profile DOUBLE, diff DOUBLE
v.univar -e map=profile column=diff
v.select ainput=points_2012 binput=mask output=points_2012_a operator=intersects
v.select ainput=points_2012 binput=mask output=points_2012_b operator=disjoint
v.edit map=points_2012_a type=point tool=move move=0,0,-0.17
v.edit map=points_2012_a type=point tool=move move=0,0,-0.17 bbox=151030,597645,150580,597195
v.patch input=points_2012_a,points_2012_b output=corrected_2012
g.remove vector=profile -f
g.remove type=vector name=profile -f
v.surf.rst input=corrected_2012 elevation=corrected_2012 tension=10 smooth=1
r.mapcalc difference_2012_2016 = elevation_2016 - corrected_2012 --overwrite
r.info map=difference_2012_2016@PERMANENT
v.edit
v.edit map=points_2012_a type=point tool=move move=0,0,-0.17 bbox=597645,151030,597195,150580
v.patch input=points_2012_a,points_2012_b output=corrected_2012 --overwrite
v.surf.rst input=corrected_2012 elevation=elevation_2012 tension=10 smooth=1
v.surf.rst input=corrected_2012 elevation=elevation_2012 tension=10 smooth=1 --overwrite
r.mapcalc difference_2012_2016 = elevation_2016 - elevation_2012 --overwrite
v.edit map=points_2012_a type=point tool=move move=0,0,0.17 bbox=597645,151030,597195,150580
v.edit map=points_2012_a type=point tool=move move=0,0,0.17 bbox=597645,151030,597195,150580
v.patch input=points_2012_a,points_2012_b output=corrected_2012 --overwrite
v.surf.rst input=corrected_2012 elevation=elevation_2012 tension=10 smooth=1 --overwrite
r.mapcalc difference_2012_2016 = elevation_2016 - elevation_2012 --overwrite
v.edit map=points_2012_a type=point tool=move move=0,0,-0.1 bbox=597645,151030,597195,150580
v.patch input=points_2012_a,points_2012_b output=corrected_2012
v.patch input=points_2012_a,points_2012_b output=corrected_2012 --overwrite
v.surf.rst input=corrected_2012 elevation=elevation_2012 tension=10 smooth=1 --overwrite
r.mapcalc difference_2012_2016 = elevation_2016 - elevation_2012 --overwrite
r.mapcalc difference_2004_2012 = elevation_2012 - elevation_2004 --overwrite
g.remove -f type=vector name=profile,points_2012_a,points_2012_b
r.in.lidar
r.in.lidar input=/Volumes/grey/fort_bragg/lidar/I-08.las output=vegetation_2012 method=max resolution=2 class_filter=5
r.in.lidar input=/Volumes/grey/fort_bragg/lidar/ncspm_I-08.las output=vegetation_2012 method=max resolution=2 class_filter=5
r.in.lidar --overwrite input=/Volumes/grey/fort_bragg/lidar/ncspm_I-08.las output=vegetation_2012 method=max resolution=2 class_filter=3,4,5
r.in.lidar --overwrite input=/Volumes/grey/fort_bragg/lidar/ncspm_I-08.las output=vegetation_2012 method=max resolution=2 return_filter=first class_filter=3,4,5
r.colors map=vegetation_2012 color=viridis
i.group group=imagery subgroup=naip_2010 input=naip_2010
i.cluster group=imagery subgroup=naip_2010 signaturefile=signature_naip_2010 classes=3
g.remove
g.remove type=group name=imagery@PERMANENT
g.remove -f type=group name=imagery@PERMANENT
g.gui
exit
g.remove
g.remove type=raster name=naip_2009@PERMANENT,naip_2010@PERMANENT,naip_2012@PERMANENT
g.remove -f type=raster name=naip_2009@PERMANENT,naip_2010@PERMANENT,naip_2012@PERMANENT
g.region region=region res=1
r.import input=/Volumes/grey/grassdata/fort_bragg_imagery/m_3507963_ne_17_1_20090603.tif output=naip_2006 memory=2047 title=naip_2006 resolution=1 extent=region
r.import input=/Volumes/grey/grassdata/fort_bragg_imagery/m_3507963_ne_17_1_20090603.tif output=naip_2009 memory=2047 title=naip_2006 resample=nearest resolution=value value=1 extent=region
r.import input=/Volumes/grey/grassdata/fort_bragg_imagery/m_3507963_ne_17_1_20090603.tif output=naip_2009 title=naip_2006 resample=nearest resolution=value resolution_value=1 extent=region
r.import input=/Volumes/grey/grassdata/fort_bragg_imagery/m_3507963_ne_17_1_20090603.tif output=naip_2009 title=naip_2009 resample=nearest resolution=value resolution_value=1 extent=region --overwrite
r.composite red=naip_2009.1 green=naip_2009.2 blue=naip_2009.3 output=naip_2009
r.import input=/Volumes/grey/grassdata/fort_bragg_imagery/m_3507963_ne_17_1_20100627.tif output=naip_2010 title=naip_2010 resample=nearest resolution=value resolution_value=1 extent=region
r.composite red=naip_2010.1 green=naip_2010.2 blue=naip_2010.3 output=naip_2010
r.import input=/Volumes/grey/grassdata/fort_bragg_imagery/n_3507963_ne_17_1_20060622.tif output=naip_2006 title=naip_2006 resample=nearest resolution=value resolution_value=1 extent=region
r.composite red=naip_2006.1 green=naip_2006.2 blue=naip_2006.3 output=naip_2006
r.import input=/Volumes/grey/grassdata/fort_bragg_imagery/m_3507963_ne_17_1_20120531.tif output=naip_2012 title=naip_2012 resample=nearest resolution=value resolution_value=1 extent=region
r.composite red=naip_2012.1 green=naip_2012.2 blue=naip_2012.3 output=naip_2012
r.import input=/Volumes/grey/grassdata/fort_bragg_imagery/m_3507963_ne_17_1_20140517.tif output=naip_2014 title=naip_2014 resample=nearest resolution=value resolution_value=1 extent=region
r.composite red=naip_2014.1 green=naip_2014.2 blue=naip_2014.3 output=naip_2014
i.group group=imagery subgroup=naip_2014 input=naip_2014.1,naip_2014.2,naip_2014.3
i.cluster group=imagery subgroup=naip_2014 signaturefile=signature_naip_2014 classes=3
i.maxlik group=imagery subgroup=naip_2014 signaturefile=signature_naip_2014 output=classification_naip_2014
r.colors map=classification_naip_2014 color=viridis
i.cluster group=imagery subgroup=naip_2014 signaturefile=signature_naip_2014 classes=4
i.cluster group=imagery subgroup=naip_2014 signaturefile=signature_naip_2014 classes=4 --overwrite
i.maxlik group=imagery subgroup=naip_2014 signaturefile=signature_naip_2014 output=classification_naip_2014 --overwrite
i.cluster group=imagery subgroup=naip_2014 signaturefile=signature_naip_2014 classes=2 --overwrite
i.maxlik group=imagery subgroup=naip_2014 signaturefile=signature_naip_2014 output=classification_naip_2014 --overwrite
i.cluster group=imagery subgroup=naip_2014 signaturefile=signature_naip_2014 classes=3 --overwrite
i.maxlik group=imagery subgroup=naip_2014 signaturefile=signature_naip_2014 output=classification_naip_2014 --overwrite
i.cluster group=imagery subgroup=naip_2014 signaturefile=signature_naip_2014 classes=2 --overwrite
i.maxlik group=imagery subgroup=naip_2014 signaturefile=signature_naip_2014 output=classification_naip_2014 --overwrite
r.recode input=classification_naip_2014 output=recode_naip_2014 rules=/Volumes/grey/grassdata/nc_spm_evolution/imagery_to_landcover.txt
r.mapcalc landcover_2014 = if(isnull(vegetation_2012), recode_naip_2014, 43)
r.colors map=landcover_2014 rules=/Volumes/grey/grassdata/nc_spm_evolution/color_landcover.txt
r.category map=landcover_2014 separator=pipe rules=/Volumes/grey/grassdata/nc_spm_evolution/landcover_categories.txt
r.colors map=landcover_2014 rules=/Volumes/grey/grassdata/nc_spm_evolution/color_landcover.txt
r.colors map=landcover_2014 rules=/Volumes/grey/grassdata/nc_spm_evolution/color_landcover.txt
r.colors map=landcover_2014 rules=/Volumes/grey/grassdata/nc_spm_evolution/color_landcover.txt
r.colors map=landcover_2014 rules=/Volumes/grey/grassdata/nc_spm_evolution/color_landcover.txt
r.recode input=landcover_2014 output=c_factor_2014 rules=/Volumes/grey/grassdata/nc_spm_evolution/landcover_to_cfactor.txt
r.colors map=c_factor_2014 color=sepia
r.recode input=landcover_2014 output=mannings_2014 rules=/Volumes/grey/grassdata/nc_spm_evolution/landcover_to_mannings.txt
r.colors map=mannings_2014 color=sepia
r.recode input=landcover_2014 output=runoff_2014 rules=/Volumes/grey/grassdata/nc_spm_evolution/landcover_to_runoff.txt
r.colors map=runoff_2014 color=water
v.import
v.import input=/Volumes/grey/grassdata/fort_bragg_data/wss_aoi_2017-05-21_15-12-11/wss_aoi_2017-05-21_15-12-11\spatial\soilmu_a_aoi.shp extent=region
v.to.rast
g.region res=0.3
g.rename
g.rename vector=soilmu_a_aoi@PERMANENT,soils
v.to.rast input=soils@PERMANENT output=soils use=cat memory=3000
r.category map=landcover_2014 separator=pipe rules=/Volumes/grey/grassdata/nc_spm_evolution/landcover_categories.txt
r.colors map=soils color=sepia
v.to.rast input=soils@PERMANENT output=soil_types use=cat memory=3000
r.recode input=soil_types output=soils rules=/Volumes/grey/grassdata/nc_spm_evolution/soil_classification.txt
r.recode input=soil_types output=soils rules=/Volumes/grey/grassdata/nc_spm_evolution/soil_classification.txt --overwrite
r.recode input=soil_types output=soils rules=/Volumes/grey/grassdata/nc_spm_evolution/soil_classification.txt
r.recode input=soil_types output=soils rules=/Volumes/grey/grassdata/nc_spm_evolution/soil_classification.txt --overwrite
r.recode input=soil_types output=soils rules=/Volumes/grey/grassdata/nc_spm_evolution/soil_classification.txt --overwrite
r.category map=soils separator=pipe rules=/Volumes/grey/grassdata/nc_spm_evolution/soil_categories.txt
g.gui
exit
g.region region=region res=0.3
r.recode input=soil_types output=soils rules=/Volumes/grey/grassdata/nc_spm_evolution/soil_classification.txt
r.recode input=soil_types output=soils rules=/Volumes/grey/grassdata/nc_spm_evolution/soil_classification.txt --overwrite
r.category map=soils separator=pipe rules=/Volumes/grey/grassdata/nc_spm_evolution/soil_categories.txt
r.recode input=landcover_2014 output=runoff_2014 rules=/Volumes/grey/grassdata/nc_spm_evolution/landcover_to_runoff.txt --overwrite
r.recode
r.recode --overwrite input=soil_types@PERMANENT output=soils rules=/Volumes/grey/grassdata/nc_spm_fort_bragg/soil_classification.txt
r.category map=soils separator=pipe rules=/Volumes/grey/grassdata/nc_spm_evolution/soil_categories.txt
r.category
r.category map=soils@PERMANENT separator=pipe rules=/Volumes/grey/grassdata/nc_spm_fort_bragg/soil_categories.txt
r.recode input=soils output=k_factor rules=/Volumes/grey/grassdata/nc_spm_evolution/soil_to_kfactor.txt
r.recode input=soils output=k_factor rules=/Volumes/grey/grassdata/nc_spm_evolution/soil_to_kfactor.txt
r.recode
r.recode input=soils@PERMANENT output=k_factor rules=/Volumes/grey/grassdata/nc_spm_fort_bragg/soil_to_kfactor.txt
r.cpt2grass -s url=http://soliton.vm.bytemark.co.uk/pub/cpt-city/mpl/inferno.cpt map=k_factor
r.colors map=k_factor@PERMANENT color=sepia
g.remove
g.remove type=raster name=corrected_2012@PERMANENT
g.remove -f type=raster name=corrected_2012@PERMANENT
g.remove -f type=raster name=soil_types@PERMANENT,recode_naip_2014@PERMANENT
g.rename
g.rename raster=c_factor_2014@PERMANENT,c_factor
g.rename raster=runoff_2014@PERMANENT,runoff
g.rename raster=mannings_2014@PERMANENT,mannings
g.rename raster=landcover_2014@PERMANENT,landcover
g.remove
g.remove -f type=raster name=classification_naip_2014@PERMANENT
g.remove -f type=raster name=classification_naip_2014@PERMANENT
g.gui
exit
g.gui
exit
/Users/Brendan/landscape_evolution/sandbox/check_extensions.py
/Users/Brendan/landscape_evolution/sandbox/check_extensions.py
/Users/Brendan/landscape_evolution/sandbox/check_extensions.py
/Users/Brendan/landscape_evolution/sandbox/check_extensions.py
/Users/Brendan/landscape_evolution/sandbox/check_extensions.py
/Users/Brendan/landscape_evolution/sandbox/check_extensions.py
/Users/Brendan/landscape_evolution/sandbox/check_extensions.py
/Users/Brendan/landscape_evolution/sandbox/check_extensions.py
/Users/Brendan/landscape_evolution/sandbox/check_extensions.py
/Users/Brendan/landscape_evolution/sandbox/check_extensions.py
/Users/Brendan/landscape_evolution/sandbox/check_extensions.py
/Users/Brendan/landscape_evolution/sandbox/check_extensions.py
/Users/Brendan/landscape_evolution/sandbox/check_extensions.py
/Users/Brendan/landscape_evolution/sandbox/check_extensions.py
/Users/Brendan/landscape_evolution/sandbox/check_extensions.py
/Users/Brendan/landscape_evolution/sandbox/check_extensions.py
g.extension r.evolution url=github.com/baharmon/landscape_evolution
g.extension r.evolution url=github.com/baharmon/landscape_evolution
r.evolution
r.evolution
d.grid
d.grid
r.info map=elevation_2016@PERMANENT
r.out.gdal input=elevation_2016@PERMANENT output=D:\rhino\elevation.png format=PNG
r.info map=elevation_2016@PERMANENT
r.out.gdal input=elevation_2016@PERMANENT output=D:\rhino\elevation.JPG format=JPEG
r.out.gdal --overwrite input=elevation_2016@PERMANENT output=D:\rhino\elevation.PNG format=PNG type=Float32
r.out.gdal --overwrite input=elevation_2016@PERMANENT output=D:\rhino\elevation.PNG format=PNG type=UInt16
r.out.gdal -f --overwrite input=elevation_2016@PERMANENT output=D:\rhino\elevation.PNG format=PNG type=UInt16
r.out.gdal --overwrite input=elevation_2016@PERMANENT output=D:\rhino\elevation.PNG format=PNG
r.out.gdal --overwrite input=elevation_2016@PERMANENT output=D:\rhino\elevation.tif
r.mapcalc
r.mapcalc expression=integer16_2016 = round( elevation_2016@PERMANENT )
r.out.gdal --overwrite input=integer16_2016@PERMANENT output=D:\rhino\elevation.png format=png
r.out.gdal --overwrite input=integer16_2016@PERMANENT output=D:\rhino\elevation.png format=PNG
g.remove
g.remove -f type=raster name=integer16_2016@PERMANENT
G.region
g.region
g.region region=region@PERMANENT res=10
r.out.xyz input=elevation_2016@PERMANENT output=D:\rhino\elevation.xyz separator=comma
g.region region=region@PERMANENT res=5
r.out.xyz input=elevation_2016@PERMANENT output=D:\rhino\elevation_5m.xyz separator=comma
g.region region=region@PERMANENT res=3
r.out.xyz input=elevation_2016@PERMANENT output=D:\rhino\elevation_3m.xyz separator=comma
g.region region=region@PERMANENT res=1
r.out.xyz input=elevation_2016@PERMANENT output=D:\rhino\elevation_1m.xyz separator=comma
g.region region=region@PERMANENT res=2
r.out.xyz input=elevation_2016@PERMANENT output=D:\rhino\elevation_2m.xyz separator=comma
g.region
g.remove
g.remove type=raster pattern=naip*.*
g.remove -f type=raster pattern=naip*.*
r.info map=elevation_2016@PERMANENT
g.region res=1
g.region n=151030 s=150580 w=597195 e=597645 save=region res=1
g.region n=151030 s=150580 w=597195 e=597645 save=region res=1 --overwrite
v.surf.rst input=points_2004 elevation=elevation_2004 tension=30 smooth=1
v.surf.rst input=points_2004 elevation=elevation_2004 tension=30 smooth=1 --overwrite
v.surf.rst input=corrected_2012 elevation=elevation_2012 tension=10 smooth=1 --overwrite
v.surf.rst input=points_2016 elevation=elevation_2016 tension=7 smooth=1
v.surf.rst input=points_2016 elevation=elevation_2016 tension=7 smooth=1 --overwrite
r.mapcalc difference_2004_2016 = elevation_2016 - elevation_2004 --overwrite
r.mapcalc difference_2004_2012 = elevation_2012 - elevation_2004 --overwrite
r.mapcalc difference_2012_2016 = elevation_2016 - elevation_2012 --overwrite
r.colors map=difference_2004_2012@PERMANENT rules=D:\grassdata\nc_spm_evolution\color_difference.txt
r.colors map=difference_2004_2016@PERMANENT,difference_2012_2016@PERMANENT rules=D:\grassdata\nc_spm_evolution\color_difference.txt
g.region n=150862 s=150712 w=597290 e=597440 save=subregion res=1
r.relief
r.relief input=elevation_2016@PERMANENT output=relief_2016
r.sahde
r.shade
r.shade shade=relief_2016@PERMANENT color=elevation_2016@PERMANENT output=shaded_relief
r.shade --overwrite shade=relief_2016@PERMANENT color=elevation_2016@PERMANENT output=shaded_relief brighten=25
r.shade --overwrite shade=relief_2016@PERMANENT color=elevation_2016@PERMANENT output=shaded_relief brighten=30
r.skyview
r.skyview input=elevation_2016@PERMANENT output=skyview_2016 ndir=16 colorized_output=colorized_skyview_2016
r.shade --overwrite shade=relief_2016@PERMANENT color=colorized_skyview_2016@PERMANENT output=shaded_relief brighten=30
r.shade --overwrite shade=relief_2016@PERMANENT color=colorized_skyview_2016@PERMANENT output=shaded_relief brighten=50
r.shade --overwrite shade=relief_2016@PERMANENT color=colorized_skyview_2016@PERMANENT output=shaded_relief brighten=60
r.shade --overwrite shade=relief_2016@PERMANENT color=colorized_skyview_2016@PERMANENT output=shaded_relief brighten=75
r.relief input=elevation_2012@PERMANENT output=relief_2012
r.skyview input=elevation_2012@PERMANENT output=skyview_2012 ndir=16 colorized_output=colorized_skyview_2012
r.shade --overwrite shade=relief_2012@PERMANENT color=colorized_skyview_2012@PERMANENT output=shaded_relief brighten=75
r.shade --overwrite shade=relief_2012@PERMANENT color=colorized_skyview_2012@PERMANENT output=shaded_relief_2012 brighten=75
r.shade --overwrite shade=relief_2016@PERMANENT color=colorized_skyview_2016@PERMANENT output=shaded_relief_2016 brighten=75
g.remove
g.remove -f type=raster name=shaded_relief@PERMANENT
r.relief input=elevation_2004@PERMANENT output=relief_2004
r.skyview input=elevation_2004@PERMANENT output=skyview_2004 ndir=16 colorized_output=colorized_skyview_2004
r.shade shade=relief_2004@PERMANENT color=colorized_skyview_2004@PERMANENT output=shaded_relief_2004 brighten=75
r.skyview --overwrite input=elevation_2016@PERMANENT output=skyview_2016 ndir=16 color_source=color_input color_input=difference_2004_2016@PERMANENT colorized_output=difference_skyview_2004_2016
r.shade shade=relief_2016@PERMANENT color=difference_skyview_2004_2016@PERMANENT output=shaded_difference_2004_2016 brighten=75
g.remove
g.remove -f type=raster name=difference_skyview_2004_2016@PERMANENT,shaded_difference_2004_2016@PERMANENT
r.contour
r.info map=landcover@PERMANENT
r.univar map=landcover@PERMANENT
g.exter
g.extension
g.extension extension=r.geomorphon operation=add
r.info map=forms@gully
r.geomorphon
r.geomorphon elevation=elevation_2016 forms=landforms search=24 skip=0 flat=1 dist=0 step=0 start=0
g.remove
g.remove -f type=raster name=landforms@PERMANENT
r.geomorphon elevation=elevation_2016 forms=landforms_2016 search=24 skip=0 flat=1 dist=0 step=0 start=0
r.geomorphon elevation=elevation_2004 forms=landforms_2004 search=24 skip=0 flat=1 dist=0 step=0 start=0
r.geomorphon elevation=elevation_2012 forms=landforms_2012 search=24 skip=0 flat=1 dist=0 step=0 start=0
r.contour input=elevation_2004@PERMANENT output=contours_2004 step=1
r.contour input=elevation_2012@PERMANENT output=contours_2012 step=1
r.contour input=elevation_2016@PERMANENT output=contours_2016 step=1
r.slope.aspect
r.slope.aspect elevation=elevation_2016@PERMANENT dx=dx_2016 dy=dy_2016
r.sim.water
r.sim.water elevation=elevation_2016@PERMANENT dx=dx_2016@PERMANENT dy=dy_2016@PERMANENT man=mannings@PERMANENT depth=depth_2016 nwalkers=60000000 output_step=1
r.sim.water elevation=elevation_2016@PERMANENT dx=dx_2016@PERMANENT dy=dy_2016@PERMANENT man=mannings@PERMANENT depth=depth_2016 nwalkers=7000000 output_step=1
r.sim.water elevation=elevation_2016@PERMANENT dx=dx_2016@PERMANENT dy=dy_2016@PERMANENT man=mannings@PERMANENT depth=depth_2016 nwalkers=5000000 output_step=1
r.sim.water --overwrite elevation=elevation_2016@PERMANENT dx=dx_2016@PERMANENT dy=dy_2016@PERMANENT man=mannings@PERMANENT depth=depth_2016 nwalkers=5000000 niterations=60 output_step=1
r.sim.water --overwrite elevation=elevation_2016@PERMANENT dx=dx_2016@PERMANENT dy=dy_2016@PERMANENT man=mannings@PERMANENT depth=depth_2016 nwalkers=5000000 output_step=1
g.remove -f type=raster name=dx,dy
g.remove -f type=raster name=dx_2016,dy_2016
r.import input=D:\fort_bragg_data/n_3507963_ne_17_1_20060622.tif output=naip_2006 title=naip_2006 resample=nearest resolution=value resolution_value=1 extent=region
r.import input=D:\fort_bragg_data/m_3507963_ne_17_1_20140517.tif output=naip_2014 title=naip_2014 resample=nearest resolution=value resolution_value=1 extent=region --overwrite
r.composite red=naip_2014.1 green=naip_2014.2 blue=naip_2014.3 output=naip_2014 --overwrite
i.group group=imagery subgroup=naip_2014 input=naip_2014.1,naip_2014.2,naip_2014.3 --overwrite
i.cluster group=imagery subgroup=naip_2014 signaturefile=signature_naip_2014 classes=2 --overwrite
i.maxlik group=imagery subgroup=naip_2014 signaturefile=signature_naip_2014 output=classification_naip_2014 --overwrite
r.recode input=classification_naip_2014 output=recode_naip_2014 rules=imagery_to_landcover.txt --overwrite
r.recode input=classification_naip_2014 output=recode_naip_2014 rules=D:\grassdata\nc_spm_evolution\imagery_to_landcover.txt --overwrite
r.mapcalc landcover = if(isnull(vegetation_2012), recode_naip_2014, 43) --overwrite
r.colors map=landcover rules==D:\grassdata\nc_spm_evolution\color_landcover.txt
r.colors map=landcover rules=D:\grassdata\nc_spm_evolution\color_landcover.txt
r.category map=landcover separator=pipe rules=D:\grassdata\nc_spm_evolution\landcover_categories.txt --overwrite
r.recode input=landcover output=c_factor rules=D:\grassdata\nc_spm_evolution\landcover_to_cfactor.txt --overwrite
r.colors map=c_factor color=sepia
r.colors map=c_factor@PERMANENT color=sepia
r.colors map=c_factor@PERMANENT color=viridis
r.recode input=landcover output=mannings rules=D:\grassdata\nc_spm_evolution\landcover_to_mannings.txt --overwrite
r.colors map=mannings color=viridis
r.recode input=landcover output=runoff rules=D:\grassdata\nc_spm_evolution\landcover_to_runoff.txt --overwrite
r.colors map=runoff color=water
g.remove -f type=raster name=soil_types,recode_naip_2014,classification_naip_2014
r.slope.aspect elevation=elevation_2016 dx=dx dy=dy
r.sim.water elevation=elevation_2016 dx=dx dy=dy man=mannings depth=depth_2016 nwalkers=5000000 output_step=1
r.sim.water elevation=elevation_2016 dx=dx dy=dy man=mannings depth=depth_2016 nwalkers=5000000 output_step=1 --overwrite
r.sim.water
r.sim.water elevation=elevation_2016 dx=dx dy=dy man=mannings depth=depth_2016 nwalkers=5000000 output_step=1 niterations=10
r.sim.water elevation=elevation_2016 dx=dx dy=dy man=mannings depth=depth_2016 nwalkers=5000000 output_step=1 niterations=10 --overwrite
g. region -p
g.region -p
g.region -p,g
g.region -pg
g.region n=160000 s=144000 w=589000 e=605000 save=fortbragg res=9
g.region n=160000 s=144000 w=587000 e=603000 save=fortbragg res=10 --overwrite
r.region
g.region n=160000 s=144000 w=587000 e=603000 save=fortbragg res=9 --overwrite
g.region n=160000 s=144000 w=587000 e=603000 save=fortbragg res=10
g.region n=160000 s=144000 w=587000 e=603000 save=fortbragg res=10 --overwrite
g.region
g.region raster=fortbragg_elevation_9m_2012@PERMANENT res=10
r.mapcalc
r.mapcalc expression=fortbragg_elevation_10m_2012 = fortbragg_elevation_10m_2012@PERMANENT   * 1.0
r.mapcalc expression=fortbragg_elevation_10m_2012 = fortbragg_elevation_9m_2012  * 1.0
r.colors map=fortbragg_elevation_10m_2012@PERMANENT color=elevation
r.colors -e map=fortbragg_elevation_10m_2012@PERMANENT color=elevation
r.mapcalc expression=fortbragg_shaded_10m_2012 = fortbragg_shaded_9m_2012  * 1.0
r.colors -e map=fortbragg_shaded_10m_2012@PERMANENT raster=fortbragg_shaded_9m_2012@PERMANENT
r.colors -e map=fortbragg_shaded_10m_2012@PERMANENT color=elevation raster=fortbragg_shaded_9m_2012@PERMANENT
r.colors -e map=fortbragg_shaded_10m_2012@PERMANENT color=elevation
r.colors map=fortbragg_shaded_10m_2012@PERMANENT color=elevation
r.colors map=fortbragg_shaded_10m_2012@PERMANENT raster=fortbragg_shaded_9m_2012@PERMANENT
g.remove
g.remove type=raster name=fortbragg_elevation_9m_2012@PERMANENT,fortbragg_shaded_9m_2012@PERMANENT
g.remove -f type=raster name=fortbragg_elevation_9m_2012@PERMANENT,fortbragg_shaded_9m_2012@PERMANENT
d.mon
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
r.info map=shaded_relief_2016@PERMANENT
r.info map=shaded_relief_2016@PERMANENT
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
g.region -pg
g.region -pg
g.region n=150870 s=150720 w=597290 e=597440 save=subregion res=1 --overwrite
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
D:\landscape_evolution\testing\render_sample_data.py
