steps = {}
#*******                 NOAA20
#VIIRS SDR
steps[:viirs_sdr] = Step.where(name: "Noaa20ViirsSdrJob").first
#VIIRS GEOTIFS
steps[:noaa20_viirs_polar_geotiff] = Step.where(name: "Noaa20ViirsGeoTiffPolar").first_or_create({
  command: "p2g_geotif.rb -m viirs_polar  -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'polar2grid',
  processing_level: ProcessingLevel.where(name: 'geotiff_polar_l1').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:viirs_sdr]
})

#VIIRS FEEDER Geotifs
steps[:noaa20_viirs_polar_feeder] = Step.where(name: "Noaa20ViirsGeoTiffPolarFeeder").first_or_create({
  command: "feeder_geotif.rb -m noaa20polar -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'geotiff',
  processing_level: ProcessingLevel.where(name: 'geotiff_polar_l2').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:noaa20_viirs_polar_geotiff]
})



#*******                 SNPP
#VIIRS SDR
steps = {}
steps[:viirs_sdr] = Step.where(name: "ViirsSdrJob").first
#VIIRS GEOTIFS
steps[:snpp_viirs_polar_geotiff] = Step.where(name: "NppViirsGeoTiffPolar").first_or_create({
  command: "p2g_geotif.rb -m viirs_polar -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'polar2grid',
  processing_level: ProcessingLevel.where(name: 'geotiff_polar_l1').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:viirs_sdr]
})

#VIIRS FEEDER Geotifs
steps[:snpp_viirs_polar_feeder] = Step.where(name: "NppViirsGeoTiffPolarFeeder").first_or_create({
  command: "feeder_geotif.rb -m snpp20polar -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'geotiff',
  processing_level: ProcessingLevel.where(name: 'geotiff_polar_l2').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:snpp_viirs_polar_geotiff]
})

# MODIS
steps = {}
steps[:terra_l1] = Step.where(name: "TerraSeadas").first
steps[:terra_polar_geotiff] = Step.where(name: "TerraModisGeoTiffPolar").first_or_create({
  command: "p2g_geotif.rb -m modis_polar  -p 4 -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'polar2grid',
  processing_level: ProcessingLevel.where(name: 'geotiff_polar_l1').first_or_create,
  sensor: Sensor.where(name: 'modis').first_or_create,
  parent: steps[:terra_l1]
   })
steps[:terra_modis_polar_feeder] = Step.where(name: "TerraGeoTiffPolarFeeder").first_or_create({
  command: "feeder_geotif.rb -m terra_polar -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'geotiff',
  processing_level: ProcessingLevel.where(name: 'geotiff_polar_l2').first_or_create,
  sensor: Sensor.where(name: 'modis').first_or_create,
  parent: steps[:terra_polar_geotiff]
})

steps = {}
steps[:aqua_l1] = Step.where(name: "AquaSeadas").first
steps[:aqua_polar_geotiff] = Step.where(name: "AquaModisGeoTiffPolar").first_or_create({
  command: "p2g_geotif.rb -m modis_polar  -p 4 -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'polar2grid',
  processing_level: ProcessingLevel.where(name: 'geotiff_polar_l1').first_or_create,
  sensor: Sensor.where(name: 'modis').first_or_create,
  parent: steps[:aqua_l1]
   })
steps[:aqua_modis_polar_feeder] = Step.where(name: "AquaGeoTiffPolarFeeder").first_or_create({
  command: "feeder_geotif.rb -m aqua_polar -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'geotiff',
  processing_level: ProcessingLevel.where(name: 'geotiff_polar_l2').first_or_create,
  sensor: Sensor.where(name: 'modis').first_or_create,
  parent: steps[:aqua_polar_geotiff]
})
