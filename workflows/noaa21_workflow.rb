steps = {}

steps[:arrival] = Step.where(name: 'Noaa21Arrival').first_or_create({
  processing_level: ProcessingLevel.where(name: 'raw').first_or_create
})
steps[:rtstps] = Step.where(name: "SNoaa21RtstpsJob").first_or_create({
  command: "rtstps.rb -p noaa21 -t {{workspace}} {{job.input_file}} {{job.output_path}}",
  queue: 'rtstps',
  processing_level: ProcessingLevel.where(name: 'level0').first_or_create,
  parent: steps[:arrival]
})


#VIIRS SDR
steps[:viirs_sdr] = Step.where(name: "Noaa21ViirsSdrJob").first_or_create({
  command: "snpp_sdr.rb -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: "cspp_sdr",
  processing_level: ProcessingLevel.where(name: 'level1').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:rtstps]
})

#VIIRS Noaa FIRE
steps[:viirs_fire] = Step.where(name: 'Noaa21ViirsFireJob').first_or_create({
  command: 'noaa_viirs_fire.rb -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  queue: 'cspp_extras',
  processing_level: ProcessingLevel.where(name: 'fire').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:viirs_sdr]
})



#VIIRS GEOTIFS
steps[:viirs_geotiff] = Step.where(name: "Noaa21ViirsGeoTiff").first_or_create({
  command: "p2g_geotif.rb -m viirs -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'polar2grid',
  processing_level: ProcessingLevel.where(name: 'geotiff_l1').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:viirs_sdr]
})

#VIIRS FEEDER Geotifs
steps[:viirs_feeder] = Step.where(name: "Noaa21ViirsFeeder").first_or_create({
  command: "feeder_geotif.rb -m noaa21 -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'geotiff',
  
  processing_level: ProcessingLevel.where(name: 'geotiff_l2').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:viirs_geotiff]
})

#VIIRS SCMI
steps[:Noaa21_viirs_scmi] = Step.where(name: 'Noaa21SnppViirsSCMI').first_or_create({
  enabled: true,
  queue: 'polar2grid',
  command: 'awips_scmi.rb -p 4 -m viirs -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "viirs").first_or_create,
  processing_level: ProcessingLevel.where(name: 'scmi').first_or_create,
  parent: steps[:viirs_sdr]
})
#VIIRS SCMI LDM
steps[:Noaa21_viirs_scmi_ldm] = Step.where(name: 'Noaa21ViirsSCMILdmInject').first_or_create({
  command: 'pqinsert.rb -t .   -p UAF_AII_{{job.facility_name.upcase}}_ {{job.input_path}}',
  queue: 'ldm',
  producer: false,
  parent: steps[:Noaa21_viirs_scmi],
  enabled: false
})

#CRIS 
steps[:cris_sdr] = Step.where(name: 'Noaa21CrisSdrJob').first_or_create({
  queue: 'cspp_sdr',
  parent: steps[:rtstps],
  enabled: false,
  command: 'snpp_sdr.rb -m cris -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "cris").first_or_create,
  processing_level: ProcessingLevel.where(name: 'level1').first_or_create
})

#ATMS
steps[:atms_sdr] = Step.where(name: 'Noaa21AtmsSdrJob').first_or_create({
  enabled: false,
  queue: 'cspp_sdr',
  command: 'snpp_sdr.rb -m atms -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "atms").first_or_create,
  processing_level: ProcessingLevel.where(name: 'level1').first_or_create,
  parent: steps[:rtstps]
})

#---------------- NUCAPS
# SDR
steps[:nucaps_sdr] = Step.where(name: 'Noaa21NucapsSdrJob').first_or_create({
  enabled: true,
  queue: 'cspp_sdr',
  command: 'nucaps_sdr.rb -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "atms").first_or_create,
  processing_level: ProcessingLevel.where(name: 'nucaps_level1').first_or_create,
  parent: steps[:rtstps]
})

# L2
steps[:nucaps] = Step.where(name: 'Noaa21NucapsL2Job').first_or_create({
  enabled: true,
  queue: 'cspp_extras',
  command: 'nucaps_l2.rb -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "atms").first_or_create,
  processing_level: ProcessingLevel.where(name: 'nucaps_level2').first_or_create,
  parent: steps[:nucaps_sdr]
})

#LDM
steps[:Noaa21_nucap_ldm] = Step.where(name: 'Noaa21NucapsLdmInject').first_or_create({
  command: 'pqinsert.rb -t . {{job.input_path}}',
  queue: 'ldm',
  producer: false,
  parent: steps[:nucaps],
  enabled: false
})

#-----------------  MIRS
# L2 MIRS
steps[:atms_mirs] = Step.where(name: 'Noaa21AtmsMirsJob').first_or_create({
  enabled: false,
  queue: 'cspp_extras',
  command: 'mirs_l0.rb -s Noaa21 -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "atms").first_or_create,
  processing_level: ProcessingLevel.where(name: 'mirs_level2').first_or_create,
  parent: steps[:atms_sdr]
})

#AWIPS
steps[:atms_mirs_awips] = Step.where(name: 'Noaa21AtmsMirsAwipsJob').first_or_create({
  enabled: false,
  queue: 'polar2grid',
  command: 'mirs_awips.rb -s atms -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "atms").first_or_create,
  processing_level: ProcessingLevel.where(name: 'mirs_awips').first_or_create,
  parent: steps[:atms_mirs]
})
#AWIPS LDM
steps[:atms_mirs_awips_ldm] = Step.where(name: 'Noaa21AtmsMirsAwipsLdmInjectJob').first_or_create({
    command: 'pqinsert.rb -t . {{job.input_path}}',
    queue: 'ldm',
    producer: false,
    parent: steps[:atms_mirs_awips],
    enabled: false
})
#SCMI
steps[:atms_mirs_scmi] = Step.where(name: 'Noaa21AtmsMirsSCMIJob').first_or_create({
  enabled: false,
  queue: 'polar2grid',
  command: 'awips_scmi.rb -m mirs -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "atms").first_or_create,
  processing_level: ProcessingLevel.where(name: 'mirs_scmi').first_or_create,
  parent: steps[:atms_mirs]
})

# SCMI LDM
steps[:atms_mirs_scmi_ldm] = Step.where(name: 'Noaa21AtmsMirsAwipsLdmInjectJob').first_or_create({
    command: 'pqinsert.rb -t . {{job.input_path}}',
    queue: 'ldm',
    producer: false,
    parent: steps[:atms_mirs_scmi],
    enabled: false
})



steps[:rtstps].requirements = [Requirement.where(name: 'rt-stps').first_or_create]
steps[:viirs_sdr].requirements = [Requirement.where(name: 'cspp_sdr').first_or_create]
steps[:viirs_geotiff].requirements = [Requirement.where(name: 'polar2grid').first_or_create]
steps[:viirs_feeder].requirements = [Requirement.where(name: 'polar2grid').first_or_create]
steps[:cris_sdr].requirements = [Requirement.where(name: 'cspp_sdr').first_or_create]
steps[:nucaps_sdr].requirements = [Requirement.where(name: 'cspp_sdr').first_or_create]
steps[:nucaps].requirements = [Requirement.where(name: 'cspp_extras').first_or_create]
steps[:Noaa21_nucap_ldm].requirements = [Requirement.where(name: 'ldm').first_or_create]
steps[:Noaa21_viirs_scmi].requirements = [Requirement.where(name: 'polar2grid').first_or_create]
steps[:Noaa21_viirs_scmi_ldm].requirements = [Requirement.where(name: 'ldm').first_or_create]


satellite = Satellite.friendly.find('Noaa21')
satellite.workflows << steps[:arrival] unless satellite.workflows.include?(steps[:arrival])
