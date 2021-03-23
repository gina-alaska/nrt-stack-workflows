steps = {}
#*******                 NOAA20
#VIIRS SDR
steps[:viirs_sdr] = Step.where(name: "Noaa20ViirsSdrJob").first
#VIIRS GEOTIFS
steps[:viirs_gm_geotiff] = Step.where(name: "Noaa20ViirsGeoTiffGm").first_or_create({
  command: "p2g_geotif.rb -m viirs_gm -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'polar2grid',
  processing_level: ProcessingLevel.where(name: 'geotiff_gm_l1').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:viirs_sdr]
})

#VIIRS FEEDER Geotifs
steps[:viirs_gm_feeder] = Step.where(name: "Noaa20ViirsGeoTiffGm2").first_or_create({
  command: "feeder_geotif.rb -m noaa20gm -t {{workspace}} {{job.input_path}} {{job.output_path}}",
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
steps[:viirs_gm_geotiff] = Step.where(name: "NppViirsGeoTiffGm").first_or_create({
  command: "p2g_geotif.rb -m viirs_gm -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'polar2grid',
  processing_level: ProcessingLevel.where(name: 'geotiff_gm_l1').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:viirs_sdr]
})

#VIIRS FEEDER Geotifs
steps[:viirs_gm_feeder] = Step.where(name: "NppViirsGeoTiffGm2").first_or_create({
  command: "feeder_geotif.rb -m snpp20gm -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'geotiff',
  processing_level: ProcessingLevel.where(name: 'geotiff_gm_l2').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:viirs_gm_geotiff]
})

