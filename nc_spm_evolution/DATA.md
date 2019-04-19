# set regions

## set patterson branch region
```
g.region n=151030 s=150580 w=597195 e=597645 save=region res=0.3
```

## set fort bragg region
```
g.region raster=fortbragg_elevation_10m_2012T save=fortbragg res=10
```

# lidar

## reproject 2004

```
cd nc_spm_fort_bragg/lidar
txt2las -skip 1 -i be3710945900go20040820.txt -o be3710945900go20040820.las -parse xyz
txt2las -skip 1 -i be3710946900go20040820.txt -o be3710946900go20040820.las -parse xyz
las2las --a_srs=EPSG:6543 --t_srs=EPSG:3358 -i be3710945900go20040820.las -o ncspm_be3710945900go20040820.las
las2las --a_srs=EPSG:6543 --t_srs=EPSG:3358 -i be3710946900go20040820.las -o ncspm_be3710946900go20040820.las
```

## reproject 2012
```
cd nc_spm_fort_bragg/lidar
las2las --a_srs=EPSG:6543 --t_srs=EPSG:3358 -i I-08.las -o ncspm_I-08.las
las2las --a_srs=EPSG:6543 --t_srs=EPSG:3358 -i J-08.las -o ncspm_J-08.las
```

## reproject 2016
```
cd nc_spm_fort_bragg/lidar
las2las 7884_1.las --scale 0.001 0.001 0.001 -o 7884_1_scaled.las
las2las --a_srs=EPSG:2264 --t_srs=EPSG:3358 -i 7884_1_scaled.las -o ncspm_7884_1.las
```

## set region
```
g.region region=region res=0.3
```

## compute digital elevation model for 2004 at 30cm resolution
```
v.in.lidar -r -t input=fort_bragg_data/ncspm_be3710945900go20040820.las output=be3710945900go20040820
v.in.lidar -r -t input=fort_bragg_data/ncspm_be3710945900go20040820.las output=be3710946900go20040820
v.patch input=be3710945900go20040820,be3710946900go20040820 output=points_204
g.remove -f type=vector name=be3710945900go20040820,be3710946900go20040820
v.kernel input=points_2004 output=kernel_2004 radius=4 kernel=uniform
r.mapcalc "voids_2004 = if(kernel_2002==0,1,null())"
r.random -d input=elevation_2012 cover=voids_2004 npoints=2% vector=fill_2004
v.patch input=points_2004,fill_2004 output=patch_2004
g.rename vector=patch_2004,points_2004 --overwrite
g.remove -f type=vector name=fill_2004
g.remove -f type=raster name=kernel_2004,voids_2004
v.surf.rst input=points_2004 elevation=elevation_2004 tension=30 smooth=1 nprocs=6
```

## compute digital elevation model for 2012 at 30cm resolution
```
v.in.lidar -r -t input=fort_bragg_data/I-08_spm.las output=i_08 class_filter=2
v.in.lidar -r -t input=fort_bragg_data/J-08_spm.las output=j_08 class_filter=2
v.patch input=i_08,j_08 output=points_2012
g.remove -f type=vector name=i_08,j_08
v.surf.rst input=points_2012 elevation=elevation_2012 tension=21 smooth=1 nprocs=6
```

## compute digital elevation model for 2016 at 30cm resolution
```
v.in.lidar -r -t input=fort_bragg_data/ncspm_7884_1.las output=points_2016
v.kernel input=points_2016 output=kernel_2016 radius=4 kernel=uniform
r.mapcalc "voids_2016 = if(kernel_2016==0,1,null())"
r.random -d input=elevation_2012 cover=voids_2016 npoints=4% vector=fill_2016
v.patch input=points_2016,fill_2016 output=patch_2016
g.rename vector=patch_2016,points_2016 --overwrite
g.remove -f type=vector name=fill_2016
g.remove -f type=raster name=kernel_2016,voids_2016
v.surf.rst input=points_2016 elevation=elevation_2016 tension=21 smooth=1 nprocs=6
```

## compute differences in time series
```
r.mapcalc "difference_2004_2016 = elevation_2016 - elevation_2004"
r.mapcalc "difference_2004_2012 = elevation_2012 - elevation_2004"
r.mapcalc "difference_2012_2016 = elevation_2016 - elevation_2012"
r.colors map=difference_2004_2012 rules=color_difference.txt
r.colors map=difference_2004_2012 rules=color_difference.txt
r.colors map=difference_2012_2016 rules=color_difference.txt
```

## fix lidar shift
```
wxGUI.vdigit
v.select ainput=points_2012 binput=mask output=points_2012_a operator=intersects
v.select ainput=points_2012 binput=mask output=points_2012_b operator=disjoint
v.edit map=points_2012_a type=point tool=move move=0,0,0.7 bbox=597645,151030,597195,150580
v.patch input=points_2012_a,points_2012_b output=corrected_2012
v.surf.rst input=corrected_2012 elevation=elevation_2012 tension=10 smooth=1 --overwrite
r.mapcalc "difference_2004_2012 = elevation_2012 - elevation_2004" --overwrite
r.mapcalc "difference_2012_2016 = elevation_2016 - elevation_2012" --overwrite
g.remove -f type=vector name=points_2012_a,points_2012_b
```

## multiple return 2012
```
r.in.lidar input=fort_bragg_data/ncspm_I-08.las output=vegetation_2012 method=max resolution=2 class_filter=3,4,5 return_filter=first
r.colors map=vegetation_2012 color=viridis
```

# watershed
```
g.region region=region res=1
r.watershed elevation=elevation_2016 threshold=300000 basin=watersheds
r.mapcalc "watershed = if(watersheds == 4, 1, null())"
r.to.vect -s input=watershed output=watershed type=area
g.remove -f type=raster name=subwatersheds,subwatershed
```

## subwatershed
```
r.mask vector=watershed
r.watershed elevation=elevation_2016 threshold=50000 basin=subwatersheds
r.to.vect -s input=subwatersheds output=subwatersheds type=area
r.mapcalc "subwatershed = if(subwatersheds == 12, 1, null())"
r.to.vect -s input=subwatershed output=subwatershed type=area
g.remove -f type=raster name=watersheds,watershed
g.region vector=subwatershed res=1 save=subregion
```

# imagery

## import imagery web mapping services

```
g.region region=region res=1
r.in.wms url=https://nccoastalatlas.org/geoserver/ows?service=wms output=naip_2009 layers=naip2009:img srs=4326 wms_version=1.3.0
r.in.wms url=https://nccoastalatlas.org/geoserver/ows?service=wms output=naip_2010 layers=naip2010:img srs=4326 wms_version=1.3.0
r.in.wms url=https://nccoastalatlas.org/geoserver/ows?service=wms output=naip_2012 layers=naip2012:img srs=4326 wms_version=1.3.0
```

## import imagery
```
g.region region=region res=1
r.import input=fort_bragg_data/n_3507963_ne_17_1_20060622.tif output=naip_2006 title=naip_2006 resample=nearest resolution=value resolution_value=1 extent=region
r.composite red=naip_2006.1 green=naip_2006.2 blue=naip_2006.3 output=naip_2006
r.import input=fort_bragg_data/m_3507963_ne_17_1_20090603.tif output=naip_2009 title=naip_2009 resample=nearest resolution=value resolution_value=1 extent=region
r.composite red=naip_2009.1 green=naip_2009.2 blue=naip_2009.3 output=naip_2009
r.import input=fort_bragg_data/m_3507963_ne_17_1_20100627.tif output=naip_2010 title=naip_2010 resample=nearest resolution=value resolution_value=1 extent=region
r.composite red=naip_2010.1 green=naip_2010.2 blue=naip_2010.3 output=naip_2010
r.import input=fort_bragg_data/m_3507963_ne_17_1_20120531.tif output=naip_2012 title=naip_2012 resample=nearest resolution=value resolution_value=1 extent=region
r.composite red=naip_2012.1 green=naip_2012.2 blue=naip_2012.3 output=naip_2012
r.import input=fort_bragg_data/m_3507963_ne_17_1_20140517.tif output=naip_2014 title=naip_2014 resample=nearest resolution=value resolution_value=1 extent=region
r.composite red=naip_2014.1 green=naip_2014.2 blue=naip_2014.3 output=naip_2014
```

## classify imagery
```
i.group group=imagery subgroup=naip_2014 input=naip_2014.1,naip_2014.2,naip_2014.3
i.cluster group=imagery subgroup=naip_2014 signaturefile=signature_naip_2014 classes=2
i.maxlik group=imagery subgroup=naip_2014 signaturefile=signature_naip_2014 output=classification_naip_2014
r.colors map=classification_naip_2014 color=viridis
```

## categorize imagery
```
r.recode input=classification_naip_2014 output=recode_naip_2014 rules=imagery_to_landcover.txt
r.mapcalc "landcover = if(isnull(vegetation_2012), recode_naip_2014, 43)"
r.colors map=landcover rules=color_landcover.txt
r.category map=landcover separator=pipe rules=landcover_categories.txt
```

## derive k factor, c factor, mannings, and runoff
```
v.import input=fort_bragg_data/wss_aoi_2017-05-21_15-12-11/wss_aoi_2017-05-21_15-12-11\spatial\soilmu_a_aoi.shp output=soils extent=region
v.to.rast input=soils output=soil_types use=cat memory=3000
r.recode input=soil_types output=soils rules=soil_classification.txt
r.category map=soils separator=pipe rules=soil_categories.txt
r.colors map=soils color=sepia
r.recode input=soils output=k_factor rules=soil_to_kfactor.txt
r.colors map=k_factor color=sepia
r.recode input=landcover output=c_factor rules=landcover_to_cfactor.txt
r.colors map=c_factor color=sepia
r.recode input=landcover output=mannings rules=landcover_to_mannings.txt
r.colors map=mannings color=sepia
r.recode input=landcover output=runoff rules=landcover_to_runoff.txt
r.colors map=runoff color=water
g.remove -f type=raster name=soil_types,recode_naip_2014,classification_naip_2014
```

# terrain analysis
```
g.region region=region res=0.3
```

## hillshade
```
r.relief input=elevation_2004 output=relief_2004
r.relief input=elevation_2012 output=relief_2012
r.relief input=elevation_2016 output=relief_2016
r.skyview input=elevation_2004 output=skyview_2004 ndir=16 colorized_output=colorized_skyview_2004
r.skyview input=elevation_2012 output=skyview_2012 ndir=16 colorized_output=colorized_skyview_2012
r.skyview input=elevation_2016 output=skyview_2016 ndir=16 colorized_output=colorized_skyview_2016
r.shade shade=relief_2004 color=colorized_skyview_2004 output=shaded_relief_2004 brighten=75
r.shade shade=relief_2012 color=colorized_skyview_2012 output=shaded_relief_2012 brighten=75
r.shade shade=relief_2016 color=colorized_skyview_2016 output=shaded_relief_2016 brighten=75
```

## contours
```
r.contour input=elevation_2004 output=contours_2004 step=1
r.contour input=elevation_2012 output=contours_2012 step=1
r.contour input=elevation_2016 output=contours_2016 step=1
```

## landforms
```
g.extension extension=r.geomorphon operation=add
r.geomorphon elevation=elevation_2004 forms=landforms_2004 search=64 skip=0 flat=1 dist=0 step=0 start=0
r.geomorphon elevation=elevation_2012 forms=landforms_2012 search=64 skip=0 flat=1 dist=0 step=0 start=0
r.geomorphon elevation=elevation_2016 forms=landforms_2016 search=64 skip=0 flat=1 dist=0 step=0 start=0
```

## sediment flow with RULSE3D
```
r.watershed elevation=elevation_2016 accumulation=flow_accumulation_2016 -a
r.slope.aspect elevation=elevation_201 slope=slope_2016
r.mapcalc "ls_factor=(0.4+1.0)*((flow_accumulation_2016/22.1)^0.4)*((sin(slope_2016)/5.14)^1.3)"
r.colors map=ls_factor color=viridis -e
r.mapcalc "sediment_flow_2016=310.0*k_factor*ls_factor*c_factor"
r.mapcalc "converted_flow=sediment_flow_2016*1000./10000."
g.rename raster=converted_flow,sediment_flow_2016 --overwrite
r.colors map=sediment_flow_2016 color=viridis -e
```

## water flow with SIMWE
```
r.slope.aspect elevation=elevation_2016 dx=dx dy=dy
r.sim.water elevation=elevation_2016 dx=dx dy=dy man=mannings depth=depth_2016 nwalkers=1000000 output_step=1 niterations=10 nprocs=6
g.remove -f type=raster name=dx,dy
```

## erosion-deposition with SIMWE
```
r.mapcalc "detachment = 0.001"
r.mapcalc "transport = 0.001"
r.mapcalc "shear_stress = 0.0"
r.sim.sediment elevation=elevation_2016 water_depth=depth_2016 dx=dx dy=dy detachment_coeff=detachment transport_coeff=transport shear_stress=shear_stress man=mannings sediment_flux=sediment_flux_2016 erosion_deposition=erosion_deposition_2016 nwalkers=1000000 output_step=1 nprocs=6
g.remove -f type=raster name=dx,dy,detachment,transport,shear_stress
```

# gully data for blender
```
g.region region=subregion res=1
r.mapcalc "elevation_2016=elevation_2016
r.mapcalc "elevation_2004=elevation_2004
r.mapcalc "bare = if(landcover == 31 , 1, 0)"
r.mapcalc "grass = if(landcover == 71 , 1, 0)"
r.mapcalc "mixed_forest = if(landcover == 43 , 1, 0)"
```
