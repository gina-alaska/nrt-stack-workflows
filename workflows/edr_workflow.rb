require 'pp'
steps = {}
sources = []


sources += %w[Noaa21ViirsSdrJob ViirsSdrJob Noaa20ViirsSdrJob]

pp sources

sources.each do |task|
  parent = task.to_sym
  task_stub = task.gsub("SdrJob", "Edr")
  task_sym = (task_stub + 'EdrJob').to_sym
  steps[parent] = Step.where(name: 'task').first
  steps[task_sym] = Step.where(name: task_stub + 'EdrJob').first_or_create({
                                                                         command: 'viirs_edr.rb -p 8 -t {{workspace}} {{job.input_path}} {{job.output_path}}',
                                                                         queue: 'edr',
                                                                         producer: true,
                                                                         processing_level: ProcessingLevel.where(name: 'level2').first_or_create,
                                                                         sensor: Sensor.where(name: 'viirs').first_or_create,
                                                                         enabled: true,
                                                                         parent: steps[parent]
                                                                       })
  scmi_task_sym = (task_stub + 'EdrScmiJob').to_sym
  steps[scmi_task_sym] = Step.where(name: task_stub + 'ScmiEdrJob').first_or_create({
                                                                         command: 'awips_scmi.rb -m edr  -t {{workspace}} {{job.input_path}} {{job.output_path}}',
                                                                         queue: 'polar2grid',
                                                                         producer: true,
                                                                         enabled: true,
                                                                         processing_level: ProcessingLevel.where(name: 'edr_scmi').first_or_create,
                                                                         sensor: Sensor.where(name: 'viirs').first_or_create,
                                                                         parent: steps[task_sym]
                                                                       })
  geotiff_task_sym = (task_stub + 'EdrGeotiffJob').to_sym
  steps[geotiff_task_sym] = Step.where(name: task_stub + 'GeoTiffEdrJob').first_or_create({
                                                                         command: 'p2g_geotif.rb -m edr  -t {{workspace}} {{job.input_path}} {{job.output_path}}',
                                                                         queue: 'polar2grid',
                                                                         producer: true,
                                                                         processing_level: ProcessingLevel.where(name: 'edr_geotiff_l1').first_or_create,
                                                                         sensor: Sensor.where(name: 'viirs').first_or_create,
                                                                         enabled: true,
                                                                         parent: steps[task_sym]
                                                                       })
  

end
