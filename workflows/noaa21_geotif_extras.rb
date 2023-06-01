#
#VIIRS GEOTIFS

steps = {}


steps[:viirs_sdr] = Step.where(name: "Noaa21ViirsSdrJob").first
# GM Geotiffs
steps[:viirs_gm_geotiff] = Step.where(name: "Noaa21ViirsGeoTiffGm").first_or_create({
  command: "p2g_geotif.rb -m viirs_gm -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'polar2grid',
  processing_level: ProcessingLevel.where(name: 'geotiff_gm_l1').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:viirs_sdr]
})

#VIIRS FEEDER Geotifs
steps[:viirs_gm_feeder] = Step.where(name: "Noaa21GeoTiffGm2").first_or_create({
  command: "feeder_geotif.rb -m noaa21gm -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'geotiff',
  processing_level: ProcessingLevel.where(name: 'geotiff_gm_l2').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:viirs_gm_geotiff]
})


# Polar Geotifs
steps[:noaa21_viirs_polar_geotiff] = Step.where(name: "Noaa21ViirsGeoTiffPolar").first_or_create({
  command: "p2g_geotif.rb -m viirs_polar  -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'polar2grid',
  processing_level: ProcessingLevel.where(name: 'geotiff_polar_l1').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:viirs_sdr]
})

steps[:noaa21_viirs_polar_feeder] = Step.where(name: "Noaa21ViirsGeoTiffPolarFeeder").first_or_create({
  command: "feeder_geotif.rb -m noaa21polar -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'geotiff',
  processing_level: ProcessingLevel.where(name: 'geotiff_polar_l2').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:noaa21_viirs_polar_geotiff]
})
