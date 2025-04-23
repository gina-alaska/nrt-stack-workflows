require 'pp'
steps = {}
sources = []


sources += %w[Noaa21ViirsSdrJob ViirsSdrJob Noaa20ViirsSdrJob]

pp sources

sources.each do |task|
  parent = task.to_sym
  task_stub = task.gsub("SdrJob", "Edr")
  task_sym = (task_stub + 'EdrJob').to_sym
  steps[parrent] = Step.where(name: 'task').first
  steps[task_sym] = Step.where(name: task_stub + 'EdrJob').first_or_create({
                                                                         command: 'viirs_edr.rb -p 8 -t {{workspace}} {{job.input_path}} {{job.output_path}}',
                                                                         queue: 'edr',
                                                                         producer: true,
                                                                         level: "level2",
                                                                         enabled: true,
                                                                         parent: steps[parrent]
                                                                       })
  scmi_task_sym = (task_stub + 'EdrScmiJob').to_sym
  steps[scmi_task_sym] = Step.where(name: task_stub + 'ScmiEdrJob').first_or_create({
                                                                         command: 'awips_scmi.rb -m edr  -t {{workspace}} {{job.input_path}} {{job.output_path}}',
                                                                         queue: 'polar2grid',
                                                                         producer: true,
                                                                         level: "edr_scmi",
                                                                         enabled: true,
                                                                         parent: steps[task_sym]
                                                                       })
  geotiff_task_sym = (task_stub + 'EdrGeotiffJob').to_sym
  steps[geotiff_task_sym] = Step.where(name: task_stub + 'GeoTiffEdrJob').first_or_create({
                                                                         command: 'p2g_geotif.rb -m edr  -t {{workspace}} {{job.input_path}} {{job.output_path}}',
                                                                         queue: 'polar2grid',
                                                                         producer: true,
                                                                         level: "edr_geotiff_l1",
                                                                         enabled: true,
                                                                         parent: steps[task_sym]
                                                                       })
  

end
