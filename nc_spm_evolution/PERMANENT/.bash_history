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
g.extension r.evolution url=github.com/baharmon/landscape_evolution
/home/baharmon/landscape_evolution/testing/steady_state_simulations.py
r.evolution
r.evolution --gui
r.evolution --ui
r.evolution
r.evolution --ui
/home/baharmon/landscape_evolution/testing/steady_state_simulations.py
g.extension r.evolution url=github.com/baharmon/landscape_evolution
/home/baharmon/landscape_evolution/testing/steady_state_simulations.py
g.extension
g.extension extension=r.evolution operation=remove
g.extension -f extension=r.evolution operation=remove
g.extension r.evolution url=github.com/baharmon/landscape_evolution
g.extension r.evolution url=github.com/baharmon/landscape_evolution
/home/baharmon/landscape_evolution/testing/steady_state_simulations.py
g.extension r.evolution url=github.com/baharmon/landscape_evolution
/home/baharmon/landscape_evolution/testing/steady_state_simulations.py
g.extension r.evolution url=github.com/baharmon/landscape_evolution
/home/baharmon/landscape_evolution/testing/steady_state_simulations.py
g.extension r.evolution url=github.com/baharmon/landscape_evolution
/home/baharmon/landscape_evolution/testing/steady_state_simulations.py
g.extension r.evolution url=github.com/baharmon/landscape_evolution
/home/baharmon/landscape_evolution/testing/steady_state_simulations.py
/home/baharmon/landscape_evolution/testing/steady_state_simulations_150.py
/home/baharmon/landscape_evolution/testing/dynamic_models.py
/home/baharmon/landscape_evolution/testing/dynamic_models_150.py
/home/baharmon/landscape_evolution/testing/dynamic_simulations.py
exit
/home/baharmon/landscape_evolution/testing/dynamic_simulations_150.py
/home/baharmon/landscape_evolution/testing/bare_simulations.py
/home/baharmon/landscape_evolution/testing/bare_simulations.py
exit
/home/baharmon/landscape_evolution/testing/bare_simulations.py
/home/baharmon/landscape_evolution/testing/bare_simulations.py
/home/baharmon/landscape_evolution/testing/bare_simulations.py
/home/baharmon/landscape_evolution/testing/bare_simulations.py
/home/baharmon/landscape_evolution/testing/bare_simulations.py
/home/baharmon/landscape_evolution/testing/bare_simulations.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
/home/baharmon/landscape_evolution/testing/bare_simulations.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
g.region res=0.3
v.surf.rst input=points_2012 elevation=elevation_30cm_2012 tension=10 smooth=1
v.surf.rst
g.remove
v.surf.rst input=points_2012 elevation=elevation_30cm_2012 tension=10 smooth=1 nprocs=6
v.surf.rst input=points_2012 elevation=elevation_30cm_2012 tension=10 smooth=1 nprocs=6
v.surf.rst input=points_2004 elevation=elevation_30cm_2004 tension=30 smooth=1 nprocs=6
v.surf.rst input=points_2016 elevation=elevation_30cm_2016 tension=7 smooth=1 nprocs=6
g.rename
g.rename raster=elevation_30cm_2016,elevation_2016
g.rename --overwrite raster=elevation_30cm_2016,elevation_2016
g.rename --overwrite raster=elevation_30cm_2012,elevation_2012
g.rename --overwrite raster=elevation_30cm_2004,elevation_2004
g.region res=0.3
r.mapcalc difference_2004_2016 = elevation_2016 - elevation_2004 --overwrite
r.mapcalc difference_2004_2012 = elevation_2012 - elevation_2004
r.mapcalc difference_2004_2012 = elevation_2012 - elevation_2004 --overwrite
r.mapcalc difference_2004_2012 = elevation_2012 - elevation_2004 --overwrite
r.mapcalc difference_2012_2016 = elevation_2016 - elevation_2012 --overwrite
r.colors map=difference_2004_2012 rules=color_difference.txt
r.colors map=difference_2004_2012 rules=color_difference.txt
r.colors
r.colors map=difference_2012_2016@PERMANENT rules=/home/baharmon/landscape_evolution_dataset/nc_spm_evolution/color_difference.txt
r.colors map=difference_2012_2016@PERMANENT,difference_2004_2016@PERMANENT rules=/home/baharmon/landscape_evolution_dataset/nc_spm_evolution/color_difference.txt
r.colors map=difference_2012_2016@PERMANENT,difference_2004_2016@PERMANENT,difference_2004_2012@PERMANENT rules=/home/baharmon/landscape_evolution_dataset/nc_spm_evolution/color_difference.txt
r.mapcalc difference_2012_2016 = elevation_2016 - elevation_2012
r.mapcalc difference_2012_2016 = elevation_2016 - elevation_2012 --overwrite
r.colors map=difference_2012_2016@PERMANENT,difference_2004_2016@PERMANENT,difference_2004_2012@PERMANENT rules=/home/baharmon/landscape_evolution_dataset/nc_spm_evolution/color_difference.txt
g.region region=region res=0.3
r.relief input=elevation_2004 output=relief_2004 --overwrite
r.relief input=elevation_2012 output=relief_2012 --overwrite
r.relief input=elevation_2016 output=relief_2016 --overwrite
r.skyview input=elevation_2004 output=skyview_2004 ndir=16 colorized_output=colorized_skyview_2004 --overwrite
r.skyview input=elevation_2012 output=skyview_2012 ndir=16 colorized_output=colorized_skyview_2012 --overwrite
r.skyview input=elevation_2016 output=skyview_2016 ndir=16 colorized_output=colorized_skyview_2016 --overwrite
r.shade shade=relief_2004 color=colorized_skyview_2004 output=shaded_relief_2004 brighten=75 --overwrite
r.shade shade=relief_2012 color=colorized_skyview_2012 output=shaded_relief_2012 brighten=75 --overwrite
r.shade shade=relief_2016 color=colorized_skyview_2016 output=shaded_relief_2016 brighten=75 --overwrite
r.geomorphon elevation=elevation_2004 forms=landforms_2004 search=24 skip=0 flat=1 dist=0 step=0 start=0 --overwrite
r.geomorphon elevation=elevation_2004 forms=landforms_2004 search=36 skip=0 flat=1 dist=0 step=0 start=0 --overwrite
r.geomorphon elevation=elevation_2004 forms=landforms_2004 search=64 skip=0 flat=1 dist=0 step=0 start=0 --overwrite
r.geomorphon elevation=elevation_2012 forms=landforms_2012 search=64 skip=0 flat=1 dist=0 step=0 start=0 --overwrite
r.geomorphon elevation=elevation_2016 forms=landforms_2016 search=64 skip=0 flat=1 dist=0 step=0 start=0 --overwrite
r.slope.aspect elevation=elevation_2016 dx=dx dy=dy
r.slope.aspect elevation=elevation_2016 dx=dx dy=dy --overwrite
r.sim.water elevation=elevation_2016 dx=dx dy=dy man=mannings depth=depth_2016 nwalkers=5000000 output_step=1 niterations=10 nprocs = 6 --overwrite
r.sim.water
r.sim.water elevation=elevation_2016 dx=dx dy=dy man=mannings depth=depth_2016 nwalkers=5000000 output_step=1 niterations=10 nprocs=6 --overwrite
r.info map=depth_2016@PERMANENT
/home/baharmon/landscape_evolution/testing/render_sample_data.py
g.region n=150870 s=150720 w=597290 e=597440 save=subregion res=0.3
g.region region=region res=0.3
v.surf.rst input=points_2016 elevation=elevation_2016 tension=10 smooth=1 nprocs=6
v.surf.rst input=points_2016 elevation=elevation_2016 tension=10 smooth=1 nprocs=6 --overwrite
r.mapcalc difference_2004_2016 = elevation_2016 - elevation_2004 --overwrite
r.mapcalc difference_2012_2016 = elevation_2016 - elevation_2012 --overwrite
v.surf.rst input=points_2016 elevation=elevation_2016 tension=12 smooth=1 nprocs=6
v.surf.rst input=points_2016 elevation=elevation_2016 tension=12 smooth=1 nprocs=6 --overwrite
r.mapcalc difference_2012_2016 = elevation_2016 - elevation_2012 --overwrite
r.mapcalc difference_2012_2016 = elevation_2016 - elevation_2012 --overwrite
v.surf.rst input=points_2016 elevation=elevation_2016 tension=18 smooth=1 nprocs=6
v.surf.rst input=points_2016 elevation=elevation_2016 tension=18 smooth=1 nprocs=6 --overwrite
r.mapcalc difference_2012_2016 = elevation_2016 - elevation_2012 --overwrite
v.surf.rst input=points_2016 elevation=elevation_2016 tension=21 smooth=1 nprocs=6 --overwrite
v.surf.rst input=points_2012 elevation=elevation_2012 tension=21 smooth=1 nprocs=6 --overwrite
r.mapcalc difference_2012_2016 = elevation_2016 - elevation_2012
r.mapcalc difference_2012_2016 = elevation_2016 - elevation_2012 --overwrite
r.mapcalc difference_2004_2016 = elevation_2016 - elevation_2004
r.mapcalc difference_2004_2016 = elevation_2016 - elevation_2004 --overwrite
r.mapcalc difference_2004_2012 = elevation_2012 - elevation_2004 --overwrite
v.surf.rst input=points_2004 elevation=elevation_2004 tension=21 smooth=1 nprocs=6 --overwrite
r.mapcalc difference_2004_2016 = elevation_2016 - elevation_2004
r.mapcalc difference_2004_2016 = elevation_2016 - elevation_2004 --overwrite
r.mapcalc difference_2004_2012 = elevation_2012 - elevation_2004
r.mapcalc difference_2004_2012 = elevation_2012 - elevation_2004 --overwrite
r.mapcalc difference_2012_2016 = elevation_2016 - elevation_2012 --overwrite
r.colors map=difference_2004_2016@PERMANENT rules=/home/baharmon/landscape_evolution_dataset/nc_spm_evolution/color_difference.txt
r.colors map=difference_2004_2016@PERMANENT,difference_2012_2016@PERMANENT,difference_2004_2012@PERMANENT rules=/home/baharmon/landscape_evolution_dataset/nc_spm_evolution/color_difference.txt
r.relief input=elevation_2004 output=relief_2004 --overwrite
r.relief input=elevation_2012 output=relief_2012 --overwrite
r.relief input=elevation_2016 output=relief_2016 --overwrite
r.skyview input=elevation_2004 output=skyview_2004 ndir=16 colorized_output=colorized_skyview_2004 --overwrite
r.skyview input=elevation_2012 output=skyview_2012 ndir=16 colorized_output=colorized_skyview_2012 --overwrite
r.skyview input=elevation_2016 output=skyview_2016 ndir=16 colorized_output=colorized_skyview_2016 --overwrite
r.shade shade=relief_2004 color=colorized_skyview_2004 output=shaded_relief_2004 brighten=75 --overwrite
r.shade shade=relief_2012 color=colorized_skyview_2012 output=shaded_relief_2012 brighten=75 --overwrite
r.shade shade=relief_2016 color=colorized_skyview_2016 output=shaded_relief_2016 brighten=75 --overwrite
r.geomorphon elevation=elevation_2004 forms=landforms_2004 search=64 skip=0 flat=1 dist=0 step=0 start=0 --overwrite
r.geomorphon elevation=elevation_2012 forms=landforms_2012 search=64 skip=0 flat=1 dist=0 step=0 start=0 --overwrite
r.geomorphon elevation=elevation_2016 forms=landforms_2016 search=64 skip=0 flat=1 dist=0 step=0 start=0 --overwrite
r.sim.water elevation=elevation_2016 dx=dx dy=dy man=mannings depth=depth_2016 nwalkers=1000000 output_step=1 niterations=10 nprocs=6
r.sim.water elevation=elevation_2016 dx=dx dy=dy man=mannings depth=depth_2016 nwalkers=1000000 output_step=1 niterations=10 nprocs=6 --overwrite
g.remove -f type=raster name=dx,dy
/home/baharmon/landscape_evolution/testing/render_sample_data.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
g.extension r.evolution url=github.com/baharmon/landscape_evolution
r.evolution
r.evolution --ui
/home/baharmon/landscape_evolution/testing/render_sample_data.py
/home/baharmon/landscape_evolution/testing/render_sample_data.py
/home/baharmon/landscape_evolution/testing/render_sample_data.py
/home/baharmon/landscape_evolution/testing/render_sample_data.py
/home/baharmon/landscape_evolution/testing/render_sample_data.py
/home/baharmon/landscape_evolution/testing/render_sample_data.py
/home/baharmon/landscape_evolution/testing/simulation_2013_2016.py
r.out.xyz input=elevation_2016@PERMANENT output=/media/baharmon/Storage/landscape_evolution_model/elevation_2016.xyz separator=comma
g.region res=0.3
r.out.xyz input=elevation_2016@PERMANENT output=/media/baharmon/Storage/landscape_evolution_model/gully_2016.xyz separator=comma
g.region region=subregion res=0.3
r.out.xyz input=elevation_2016@PERMANENT output=/media/baharmon/Storage/landscape_evolution_model/gully_2016.xyz separator=comma
/home/baharmon/landscape_evolution/testing/steady_state_simulations.py
/home/baharmon/landscape_evolution/testing/steady_state_simulations.py
/home/baharmon/landscape_evolution/testing/dynamic_simulations.py
/home/baharmon/landscape_evolution/testing/dynamic_simulations_2.py
/home/baharmon/landscape_evolution/testing/ss_flux.py
/home/baharmon/landscape_evolution/testing/ss_flux.py
/home/baharmon/landscape_evolution/testing/ss_flux.py
/home/baharmon/landscape_evolution/testing/ss_flux.py
/home/baharmon/landscape_evolution/testing/ss_erdep.py
/home/baharmon/landscape_evolution/testing/ss_erdep.py
/home/baharmon/landscape_evolution/testing/ss_erdep.py
/home/baharmon/landscape_evolution/testing/ss_erdep.py
/home/baharmon/landscape_evolution/testing/dynamic_simulations.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
/home/baharmon/landscape_evolution/testing/dynamic_simulations.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
/home/baharmon/landscape_evolution/testing/simulation_2013_2016.py
g.extension r.evolution url=github.com/baharmon/landscape_evolution
/home/baharmon/landscape_evolution/r.evolution.py
/home/baharmon/landscape_evolution/testing/steady_state_simulations.py
exit
/home/baharmon/landscape_evolution/testing/debug.py
/home/baharmon/landscape_evolution/testing/steady_state_simulations.py
/home/baharmon/landscape_evolution/testing/steady_state_simulations.py
/home/baharmon/landscape_evolution/testing/sandbox/ss_flux.py
exit
/home/baharmon/landscape_evolution/testing/sandbox/ss_flux.py
/home/baharmon/landscape_evolution/testing/sandbox/ss_rusle.py
/home/baharmon/landscape_evolution/testing/sandbox/ss_rusle.py
/home/baharmon/landscape_evolution/testing/simulation_2013_2016.py
/home/baharmon/landscape_evolution/testing/bragg_simulations.py
/home/baharmon/landscape_evolution/testing/bragg_simulations.py
/home/baharmon/landscape_evolution/testing/fractal_simulations.py
/home/baharmon/landscape_evolution/testing/fractal_simulations.py
/home/baharmon/landscape_evolution/testing/dynamic_simulations.py
/home/baharmon/landscape_evolution/testing/dynamic_simulations.py
/home/baharmon/landscape_evolution/testing/dynamic_simulations.py
g.extension r.evolution url=github.com/baharmon/landscape_evolution
/home/baharmon/landscape_evolution/testing/dynamic_simulations.py
/home/baharmon/landscape_evolution/testing/bragg_simulations.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
/home/baharmon/landscape_evolution/sandbox/design_storm.py
/home/baharmon/landscape_evolution/sandbox/design_storm.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
/home/baharmon/landscape_evolution/testing/simulation_2004_2016.py
/home/baharmon/landscape_evolution/testing/design_storm_simulations.py
r.info map=elevation_2012@PERMANENT
r.info map=elevation_2016@PERMANENT
r.info map=elevation_2012@PERMANENT
g.region res=1
g.mapset
g.region raster=elevation_2016 res=1
g.mapset -c mapset=fractal_ss_erdep
g.mapset mapset=subregion -c
g.mapset mapset=fractal_ss_erdep
/home/baharmon/landscape_evolution/testing/sandbox/ss_rusle.py
/home/baharmon/landscape_evolution/testing/dynamic_simulations.py
/home/baharmon/landscape_evolution/testing/dynamic_simulations.py
/home/baharmon/landscape_evolution/testing/sandbox/dynamic_models.py
exit
r.report
r.stats -p input=landcover@PERMANENT
r.univar map=soils@PERMANENT
r.stats
r.stats -p input=soils@PERMANENT
r.info map=landcover@PERMANENT
/home/baharmon/landscape_evolution/testing/render_sample_data.py
/home/baharmon/landscape_evolution/testing/render_sample_data.py
/home/baharmon/landscape_evolution/testing/render_sample_data.py
/home/baharmon/landscape_evolution/testing/render_sample_data.py
/home/baharmon/landscape_evolution/testing/render_sample_data.py
/Users/Brendan/landscape_evolution/testing/render_sample_data.py
/Users/Brendan/landscape_evolution/testing/render_sample_data.py
exit
/Users/Brendan/landscape_evolution/testing/render_sample_data.py
exit
r.unpack
r.unpack -o input=/home/baharmon/Downloads/fortbragg_landcover.pack output=fortbragg_landcover
r.unpack -o input=/home/baharmon/Downloads/fortbragg_cfactor.pack output=fortbragg_cfactor
r.unpack -o input=/home/baharmon/Downloads/fortbragg_erdep.pack output=fortbragg_erdep
r.unpack -o input=/home/baharmon/Downloads/fortbragg_erdep_class.pack output=fortbragg_classified_erdep
r.watershed elevation=elevation_2016 accumulation=flow_accumulation_2016
r.mapcalc ls_factor=(0.4+1.0)*((flow_accumulation_2016/22.1)^0.4)*((sin(slope_2016)/0.09)^1.3)
r.mp
r.mapcalc
r.mapcalc ls_factor=(0.4+1.0)*((flow_accumulation_2016/22.1)^0.4)*((sin(slope_2016)/0.09)^1.3)
r.mapcalc expression=ls_factor = (0.4+1.0)*((flow_accumulation_2016/22.1)^0.4)*((sin(slope_2016)/0.09)^1.3)
r.slope.aspect
r.slope.aspect elevation=elevation_2016@PERMANENT slope=slope_2016
r.mapcalc expression=ls_factor = (0.4+1.0)*((flow_accumulation_2016/22.1)^0.4)*((sin(slope_2016)/0.09)^1.3)
r.colors map=ls_factor color=viridis -e
r.mapcalc --overwrite expression=ls_factor = (0.4+1.0)*((flow_accumulation_2016/22.1)^0.4)*((sin(slope_2016)/5.14)^1.3)
r.colors map=ls_factor color=viridis -e
r.mask
r.mask -r
r.slope.aspect
r.slope.aspect --overwrite elevation=elevation_2016@PERMANENT slope=slope_2016 format=percent
r.mapcalc --overwrite expression=ls_factor = (0.4+1.0)*((flow_accumulation_2016/22.1)^0.4)*((sin(slope_2016)/9)^1.3)
r.slope.aspect --overwrite elevation=elevation_2016@PERMANENT slope=slope_2016 format=percent
r.colors map=ls_factor color=viridis -e
r.slope.aspect --overwrite elevation=elevation_2016@PERMANENT slope=slope_2016
r.mapcalc --overwrite expression=ls_factor = (0.4+1.0)*((flow_accumulation_2016/22.1)^0.4)*((sin(slope_2016)/5.14)^1.3)
r.mapcalc
r.mapcalc expression=sediment_flow = 310.0*k_factor*ls_factor*c_factor
r.colors map=sediment_flow color=viridis -e
g.remove
g.remove -f type=raster name=ls_factor@PERMANENT,sediment_flow@PERMANENT
r..sim.sediment
r.sim.sediment
r.slope.aspect
r.slope.aspect elevation=elevation_2016@PERMANENT dx=dx dy=dy
g.remove
r.mapcalc
r.mapcalc expression=detachment = 0.001
r.mapcalc expression=transport = 0.001
r.mapcalc expression=shear_stress = 0.0
r.sim.sediment elevation=elevation_2016 water_depth=depth_2016 dx=dx dy=dy detachment_coeff=detachment transport_coeff=transport shear_stress=shear_stress man=mannings sediment_flux=sediment_flux_2016 erosion_deposition=erosion_deposition_2016 nwalkers=1000000 output_step=1 nprocs=6
g.remove -f type=raster name=dx,dy,detachment,transport,shear_stress
r.mapcalc
exit
g.region raster=elevation_2016@PERMANENT
g.region raster=elevation_2016@PERMANENT
r.mapcalc
r.mapcalc expression=ls_factor = (0.4+1.0)*((flow_accumulation_2016/22.1)^0.4)*((sin(slope_2016)/5.14)^1.3)
r.mapcalc --overwrite expression=ls_factor = (0.4+1.0)*((flow_accumulation_2016/22.1)^0.4)
r.mapcalc --overwrite expression=ls_factor = ((sin(slope_2016)/5.14)^1.3)
r.mapcalc --overwrite expression=ls_factor = ((flow_accumulation_2016/22.1)^0.4)*((sin(slope_2016)/5.14)^1.3)
r.mapcalc --overwrite expression=ls_factor = (0.4+1.0)*((flow_accumulation_2016)^0.4)*((sin(slope_2016)/5.14)^1.3)
r.mapcalc --overwrite expression=ls_factor = (0.4+1.0)*((flow_accumulation_2016/22.1))*((sin(slope_2016)/5.14)^1.3)
r.mapcalc --overwrite expression=ls_factor = (0.4+1.0)*((flow_accumulation_2016/22.1)^1)*((sin(slope_2016)/5.14)^1.3)
r.mapcalc --overwrite expression=ls_factor = (0.4+1.0)*((flow_accumulation_2016/22.1)^0.9)*((sin(slope_2016)/5.14)^1.3)
r.mapcalc --overwrite expression=ls_factor = (0.4+1.0)*((flow_accumulation_2016/22.1)^1.2)*((sin(slope_2016)/5.14)^1.3)
r.mapcalc --overwrite expression=ls_factor = (0.4+1.0)*((flow_accumulation_2016/22.1)^1.2)*((sin(slope_2016)/5.14)^1.3)
r.mapcalc --overwrite expression=ls_factor = (0.4+1.0)*(flow_accumulation_2016/22.1)^0.4*((sin(slope_2016)/5.14)^1.3)
r.mapcalc --overwrite expression=ls_factor = (0.4+1.0)*((flow_accumulation_2016/22.1)^0.4)*((sin(slope_2016)/5.14)^1.3)
r.mapcalc --overwrite expression=ls_factor = ((0.4+1.0)*(flow_accumulation_2016/22.1)^0.4)*((sin(slope_2016)/5.14)^1.3)
r.mapcalc --overwrite expression=ls_factor = (0.4+1.0)*(flow_accumulation_2016/22.1)^0.4*((sin(slope_2016)/5.14)^1.3)
r.mapcalc --overwrite expression=ls_factor = (0.4+1.0)*flow_accumulation_2016/22.1^0.4*((sin(slope_2016)/5.14)^1.3)
r.mapcalc --overwrite expression=ls_factor = (0.4+1.0)*(flow_accumulation_2016/22.1)^0.4*((sin(slope_2016)/5.14)^1.3)
r.mapcalc --overwrite expression=ls_factor = (0.4+1.0)*(flow_accumulation_2016^0.4/22.1)*((sin(slope_2016)/5.14)^1.3)
r.watershed
r.watershed -a --overwrite elevation=elevation_2016 accumulation=flow_accumulation
r.mapcalc --overwrite expression=ls_factor = (0.4+1.0)*((flow_accumulation_2016/22.1)^0.4)*((sin(slope_2016)/5.14)^1.3)
r.mapcalc --overwrite expression=ls_factor = (0.4+1.0)*((flow_accumulation_2016/22.1)^0.4)*((sin(slope_2016)/5.14)^1.3)
r.colors map=ls_factor color=viridis -e
g.rename
g.rename raster=flow_accumulation,flow_accumulation_2016
g.rename --overwrite raster=flow_accumulation,flow_accumulation_2016
r.mapcalc --overwrite expression=ls_factor = (0.4+1.0)*((flow_accumulation_2016/22.1)^0.4)*((sin(slope_2016)/5.14)^1.3)
r.colors map=ls_factor color=viridis -e
r.mapcalc --overwrite expression=sediment_flow = 310.0*k_factor*ls_factor*c_factor
r.mapcalc --overwrite expression=converted_flow = sediment_flow*1000./10000.
r.colors map=converted_flow color=viridis -e
g.rename
g.rename --overwrite raster=converted_flow@PERMANENT,sediment_flow
r.colors -e map=sediment_flow@PERMANENT color=viridis
r.colors -a map=sediment_flow@PERMANENT color=viridis
r.colors map=sediment_flow@PERMANENT color=viridis
r.colors -e map=sediment_flow@PERMANENT color=viridis
/Users/Brendan/landscape_evolution/testing/render_sample_data.py
/Users/Brendan/landscape_evolution/testing/render_sample_data.py
/Users/Brendan/landscape_evolution/testing/render_sample_data.py
/Users/Brendan/landscape_evolution/testing/render_sample_data.py
g.rename
g.rename
g.rename raster=sediment_flow@PERMANENT,sediment_flow_2016
g.rename raster=sediment_flow@PERMANENT,sediment_flow_2016
/Users/Brendan/landscape_evolution/testing/render_sample_data.py
/Users/Brendan/landscape_evolution/testing/render_sample_data.py
d.vect
/Users/Brendan/landscape_evolution/testing/render_sample_data.py
/Users/Brendan/landscape_evolution/testing/render_sample_data.py
/Users/Brendan/landscape_evolution/testing/render_sample_data.py
/Users/Brendan/landscape_evolution/testing/render_sample_data.py
/Users/Brendan/landscape_evolution/testing/render_sample_data.py
/Users/Brendan/landscape_evolution/testing/render_sample_data.py
/Users/Brendan/landscape_evolution/testing/render_sample_data.py
/Users/Brendan/landscape_evolution/testing/render_sample_data.py
exit
/home/baharmon/landscape_evolution/testing/dynamic_simulations.py
/home/baharmon/landscape_evolution/testing/dynamic_usped.py
/home/baharmon/landscape_evolution/testing/steady_state_rusle.py
/home/baharmon/landscape_evolution/testing/steady_state_usped.py
g.extension extension=r.skyview
g.extension r.sim.terrain url=github.com/baharmon/landscape_evolution
g.extension extension=r.stream*
g.extension extension=r.stream
g.extension extension=r.stream.distance
g.extension extension=r.stream.order
/home/baharmon/landscape_evolution/testing/steady_state_usped.py
g.region
g.region --overwrite raster=fortbragg_elevation_10m_2012@PERMANENT save=fortbragg
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/bragg_simulations.py
g.mapset mapset=ss_erdep
g.extension.all -f
g.remove
g.remove -f type=raster name=relief@PERMANENT
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
g.region res=1
r.colors
r.colors map=sediment_flux_2016@PERMANENT,sediment_flow_2016@PERMANENT rules=/home/baharmon/landscape_evolution_dataset/nc_spm_evolution/color_sedflux.txt
/home/baharmon/landscape_evolution/scripts/dynamic_rusle.py
g.extension extension=r.sim.terrain url=github.com/baharmon/landscape_evolution
r.sim.terrain
r.sim.terrain --ui
g.extension
g.extension extension=r.erosion operation=add url=/home/baharmon/r.erosion/r.erosion.py
g.extension extension=r.erosion operation=add url=/home/baharmon/r.erosion
g.extension extension=r.erosion operation=add url=/home/baharmon/r.erosion
g.extension extension=r.erosion operation=add url=/home/baharmon/r.erosion
r.erosion
r.watershed elevation=elevation_2016 threshold=50000 basin=subwatersheds
r.mask
r.mask vector=watershed@PERMANENT
r.watershed elevation=elevation_2016 threshold=50000 basin=subwatersheds --overwrite
r.to.vect -s input=subwatersheds output=subwatersheds type=area
r.mapcalc subwatershed = if(subwatersheds == 12, 1, null())
r.to.vect -s input=subwatershed output=subwatershed type=area
g.remove -f type=raster name=subwatershed
g.remove -f type=raster name=subwatersheds
r.mask vector=subwatershed@PERMANENT
r.mask -r vector=subwatershed@PERMANENT
r.mask -r vector=subwatershed@PERMANENT
r.mask vector=subwatershed@PERMANENT
r.mask -r vector=subwatershed@PERMANENT
r.mask -r vector=watershed@PERMANENT
r.mask vector=watershed@PERMANENT
g.region region=region -p
g.region
g.region --overwrite vector=subwatershed@PERMANENT res=1 save=subregion
/home/baharmon/landscape_evolution/scripts/render_simulations.py
r.mask -r
/home/baharmon/landscape_evolution/scripts/render_simulations.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_simulations.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
r.colors map=ls_factor@PERMANENT rules=/home/baharmon/landscape_evolution_dataset/nc_spm_evolution/color_lsfactor.txt
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
d.legend
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
r.relief input=elevation_2012 output=relief_2012 altitude=80 zscale=0.3
r.relief input=elevation_2012 output=relief_2012 altitude=80 zscale=0.3 --overwrite
r.relief input=elevation_2004 output=relief_2004 altitude=80 zscale=0.3 --overwrite
r.relief input=elevation_2016 output=relief_2016 altitude=80 zscale=0.3 --overwrite
r.shade shade=relief_2004 color=colorized_skyview_2004 output=shaded_relief_2004 brighten=75 --overwrite
r.shade shade=relief_2012 color=colorized_skyview_2012 output=shaded_relief_2012 brighten=75
r.shade shade=relief_2012 color=colorized_skyview_2012 output=shaded_relief_2012 brighten=75 --overwrite
r.shade shade=relief_2016 color=colorized_skyview_2016 output=shaded_relief_2016 brighten=75 --overwrite
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
r.relief input=elevation_2004 output=relief_2004 --overwrite
r.relief input=elevation_2012 output=relief_2012 --overwrite
r.relief input=elevation_2016 output=relief_2016 --overwrite
r.shade shade=relief_2004 color=colorized_skyview_2004 output=shaded_relief_2004 brighten=75 --overwrite
r.shade shade=relief_2012 color=colorized_skyview_2012 output=shaded_relief_2012 brighten=75 --overwrite
r.shade shade=relief_2016 color=colorized_skyview_2016 output=shaded_relief_2016 brighten=75 --overwrite
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
/home/baharmon/landscape_evolution/scripts/render_sample_data.py
