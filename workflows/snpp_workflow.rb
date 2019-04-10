steps = {}

steps[:arrival] = Step.where(name: 'SnppArrival').first_or_create({
  processing_level: ProcessingLevel.where(name: 'raw').first_or_create
})
steps[:rtstps] = Step.where(name: "SnppRtstpsJob").first_or_create({
  command: "rtstps.rb -p npp -t {{workspace}} {{job.input_file}} {{job.output_path}}",
  queue: 'rtstps',
  processing_level: ProcessingLevel.where(name: 'level0').first_or_create,
  parent: steps[:arrival]
})

steps[:viirs_sdr] = Step.where(name: "ViirsSdrJob").first_or_create({
  command: "snpp_sdr.rb -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: "cspp_sdr",
  processing_level: ProcessingLevel.where(name: 'level1').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:rtstps]
})

steps[:viirs_edr] = Step.where(name: "ViirsEdrJob").first_or_create({
  command: 'viirs_edr.rb -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  queue: 'viirs_edr',
  processing_level: ProcessingLevel.where(name: 'level2').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:viirs_sdr]
})

steps[:viirs_awips] = Step.where(name: 'ViirsAwipsJob').first_or_create({
  command: 'viirs_awips.rb -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  queue: 'polar2grid',
  processing_level: ProcessingLevel.where(name: 'awips').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:viirs_sdr]
})

steps[:viirs_geotiff] = Step.where(name: "ViirsGeoTiff").first_or_create({
  command: "p2g_geotif.rb -m viirs -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'polar2grid',
  processing_level: ProcessingLevel.where(name: 'geotiff_l1').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:viirs_sdr]
})

steps[:viirs_feeder] = Step.where(name: "ViirsFeeder").first_or_create({
  command: "feeder_geotif.rb -m npp -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: 'geotiff',
  processing_level: ProcessingLevel.where(name: 'geotiff_level2').first_or_create,
  sensor: Sensor.where(name: 'viirs').first_or_create,
  parent: steps[:viirs_geotiff],
  producer: false,
  enabled: false
})

steps[:viirs_ldm] = Step.where(name: 'ViirsLdmInject').first_or_create({
  command: 'pqinsert.rb -t . -s \"VIIRS_ALASK\" {{job.input_path}}',
  queue: 'ldm',
  producer: false,
  parent: steps[:viirs_awips],
  enabled: false
})

steps[:cris_sdr] = Step.where(name: 'CrisSdrJob').first_or_create({
  queue: 'cspp_sdr',
  parent: steps[:rtstps],
  enabled: false,
  command: 'snpp_sdr.rb -m cris -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "cris").first_or_create,
  processing_level: ProcessingLevel.where(name: 'level1').first_or_create
})

steps[:cris_hyperspectral] = Step.where(name: 'CrisHyperspectralJob').first_or_create({
  queue: 'uw-hyperspectral',
  parent: steps[:cris_sdr],
  enabled: false,
  processing_level: ProcessingLevel.where(name: 'level2').first_or_create,
  sensor: Sensor.where(name: 'cris').first_or_create
})

steps[:atms_sdr] = Step.where(name: 'AtmsSdrJob').first_or_create({
  enabled: false,
  queue: 'cspp_sdr',
  command: 'snpp_sdr.rb -m atms -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "atms").first_or_create,
  processing_level: ProcessingLevel.where(name: 'level1').first_or_create,
  parent: steps[:rtstps]
})

#ATMS MIRS
steps[:atms_mirs] = Step.where(name: 'AtmsMirsJob').first_or_create({
  enabled: false,
  queue: 'cspp_extras',
  command: 'mirs_l0.rb -s atms -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "atms").first_or_create,
  processing_level: ProcessingLevel.where(name: 'mirs_level2').first_or_create,
  parent: steps[:atms_sdr]
})

steps[:atms_mirs_awips] = Step.where(name: 'AtmsMirsAwipsJob').first_or_create({
  enabled: false,
  queue: 'polar2grid',
  command: 'mirs_awips.rb -s atms -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "atms").first_or_create,
  processing_level: ProcessingLevel.where(name: 'mirs_awips').first_or_create,
  parent: steps[:atms_mirs]
})


#SST
steps[:sst] = Step.where(name: 'SSTJob').first_or_create({
  enabled: false,
  queue: 'cspp_extras',
  command: 'acspo_level2.rb -m npp -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "viirs").first_or_create,
  processing_level: ProcessingLevel.where(name: 'acspo_level2').first_or_create,
  parent: steps[:viirs_sdr]
})

steps[:sst_awips] = Step.where(name: 'SSTAwipsJob').first_or_create({
  enabled: false,
  queue: 'polar2grid',
  command: 'acspo_awips.rb -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "viirs").first_or_create,
  processing_level: ProcessingLevel.where(name: 'sst_awips').first_or_create,
  parent: steps[:sst]
})

steps[:sst_geotiff] = Step.where(name: 'SSTGeotifJob').first_or_create({
  enabled: false,
  queue: 'polar2grid',
  command: 'acspo_geotif.rb -m viirs -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "viirs").first_or_create,
  processing_level: ProcessingLevel.where(name: 'sst_geotif').first_or_create,
  parent: steps[:sst]
})

#Sport
steps[:sport] = Step.where(name: 'SportSlice').first_or_create({
  enabled: false,
  queue: 'polar2grid',
  command: 'sport_slice.rb -m viirs -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "viirs").first_or_create,
  processing_level: ProcessingLevel.where(name: 'binary_slice').first_or_create,
  parent: steps[:viirs_sdr]
})

#SCMI
steps[:snpp_viirs_scmi] = Step.where(name: 'SnppViirsSCMI').first_or_create({
    enabled: false,
    queue: 'polar2grid',
    command: 'awips_scmi.rb -m viirs -t {{workspace}} {{job.input_path}} {{job.output_path}}',
    sensor: Sensor.where(name: "viirs").first_or_create,
    processing_level: ProcessingLevel.where(name: 'scmi').first_or_create,
    parent: steps[:viirs_sdr]
})

steps[:snpp_viirs_scmi_ldm] = Step.where(name: 'SnppViirsSCMILdmInject').first_or_create({
    command: 'pqinsert.rb -t . -s \"VIIRS_ALASK\" {{job.input_path}}',
    queue: 'ldm',
    producer: false,
    parent: steps[:snpp_viirs_scmi],
    enabled: false
})


#NUCAPS
#nucaps_sdr.rb
steps[:nucaps_sdr] = Step.where(name: 'NucapsSdrJob').first_or_create({
  enabled: true,
  queue: 'cspp_sdr',
  command: 'nucaps_sdr.rb -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "atms").first_or_create,
  processing_level: ProcessingLevel.where(name: 'nucaps_level1').first_or_create,
  parent: steps[:rtstps]
})

#nucaps_l2.rb 
steps[:nucaps] = Step.where(name: 'NucapsL2Job').first_or_create({
  enabled: true,
  queue: 'cspp_extras',
  command: 'nucaps_l2.rb -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "atms").first_or_create,
  processing_level: ProcessingLevel.where(name: 'nucaps_level2').first_or_create,
  parent: steps[:nucaps_sdr]
})


#"clavrx_l2.rb -m npp #{source_dir}/ #{target_dir}"
steps[:clavrx] = Step.where(name: 'SNPP_CLAVRX_Job').first_or_create({
  enabled: true, 
  queue: 'cspp_extras',
  command: 'clavrx_l2.rb -m npp -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "viirs").first_or_create,
  processing_level: ProcessingLevel.where(name: 'clavrx_level2').first_or_create,
  parent: steps[:viirs_sdr]
 })

steps[:clavrx_geotiff] = Step.where(name: 'SNPP_CLAVRX_GEOTIFF_Job').first_or_create({
  enabled: true,
  queue: 'polar2grid',
  command: 'p2g_geotif.rb -p 8 -m viirs_clavrx -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "viirs").first_or_create,
  processing_level: ProcessingLevel.where(name: 'clavrx_geotiff_l1').first_or_create,
  parent: steps[:clavrx]
 })


steps[:clavrx_awips] = Step.where(name: 'SNPP_CLAVRX_AWIPS_Job').first_or_create({
  enabled: true,
  queue: 'polar2grid',
  command: 'awips_scmi.rb -m clavrx -t {{workspace}} {{job.input_path}} {{job.output_path}}',
  sensor: Sensor.where(name: "viirs").first_or_create,
  processing_level: ProcessingLevel.where(name: 'clavrx_scmi').first_or_create,
  parent: steps[:clavrx]
 })


steps[:rtstps].requirements = [Requirement.where(name: 'rt-stps').first_or_create]
steps[:viirs_sdr].requirements = [Requirement.where(name: 'cspp_sdr').first_or_create]
steps[:viirs_edr].requirements = [Requirement.where(name: 'viirs_edr').first_or_create]
steps[:viirs_awips].requirements = [Requirement.where(name: 'polar2grid').first_or_create]
steps[:viirs_geotiff].requirements = [Requirement.where(name: 'polar2grid').first_or_create]
steps[:viirs_feeder].requirements = [Requirement.where(name: 'polar2grid').first_or_create]
steps[:viirs_ldm].requirements = [Requirement.where(name: 'ldm').first_or_create]
steps[:cris_sdr].requirements = [Requirement.where(name: 'cspp_sdr').first_or_create]
steps[:cris_hyperspectral].requirements = [Requirement.where(name: 'uw-hyperspectral').first_or_create]
steps[:atms_mirs].requirements = [Requirement.where(name: 'cspp_extras').first_or_create]
steps[:atms_mirs_awips].requirements = [Requirement.where(name: 'polar2grid').first_or_create]
steps[:sst].requirements = [Requirement.where(name: 'cspp_extras').first_or_create]
steps[:sst_awips].requirements = [Requirement.where(name: 'polar2grid').first_or_create]
steps[:sst_geotiff].requirements = [Requirement.where(name: 'polar2grid').first_or_create]
steps[:sport].requirements = [Requirement.where(name: 'polar2grid').first_or_create]
steps[:snpp_viirs_scmi].requirements = [Requirement.where(name: 'polar2grid').first_or_create]
steps[:snpp_viirs_scmi_ldm].requirements = [Requirement.where(name: 'ldm').first_or_create]
steps[:nucaps_sdr].requirements = [Requirement.where(name: 'cspp_sdr').first_or_create]
steps[:nucaps].requirements = [Requirement.where(name: 'cspp_extras').first_or_create]
steps[:clavrx].requirements = [Requirement.where(name: 'cspp_extras').first_or_create]
steps[:clavrx_awips].requirements = [Requirement.where(name: 'polar2grid').first_or_create]

satellite = Satellite.friendly.find('snpp')
satellite.workflows << steps[:arrival] unless satellite.workflows.include?(steps[:arrival])
