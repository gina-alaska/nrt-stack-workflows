steps = {}
#*******                 NOAA20
#VIIRS SDR
steps[:viirs_sdr] = Step.where(name: "Noaa20ViirsSdrJob").first
#VIIRS GEOTIFS
steps[:noaa20_viirs_polar_geotiff] = Step.where(name: "Noaa20ViirsGeoTiffPolar").first_or_create({
  command: "p2g_geotif.rb -m viirs_polar  -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'polar2grid',
  processing_level: ProcessingLevel.where(name: 'geotiff_gm_l1').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:viirs_sdr]
})

#VIIRS FEEDER Geotifs
steps[:noaa20_viirs_polar_feeder] = Step.where(name: "Noaa20ViirsGeoTiffPolar2").first_or_create({
  command: "feeder_geotif.rb -m noaa20polar -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'geotiff',
  processing_level: ProcessingLevel.where(name: 'geotiff_gm_l2').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:viirs_gm_geotiff]
})

steps = {}
#*******                 SNPP
#VIIRS SDR
steps[:viirs_sdr] = Step.where(name: "ViirsSdrJob").first

#
#VIIRS GEOTIFS
steps[:snpp_viirs_polar_geotiff] = Step.where(name: "NppViirsGeoTiffPolar").first_or_create({
  command: "p2g_geotif.rb -m viirs_polar -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'polar2grid',
  processing_level: ProcessingLevel.where(name: 'geotiff_gm_l1').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:viirs_sdr]
})

#VIIRS FEEDER Geotifs
steps[:snpp_viirs_polar_feeder] = Step.where(name: "NppViirsGeoTiffGm2").first_or_create({
  command: "feeder_geotif.rb -m snpp20polar -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'geotiff',
  processing_level: ProcessingLevel.where(name: 'geotiff_gm_l2').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:viirs_gm_geotiff]
})

