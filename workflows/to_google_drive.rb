require 'pp'
steps = {}
sources = []

# noaa20
#sources += %w[Noaa20ViirsFeeder Noaa20ViirsFireJob Noaa20ViirsGeoTiff Noaa20ViirsGeoTiffGm2
#              Noaa20ViirsGeoTiffGm Noaa20ViirsGeoTiffPolar Noaa20ViirsGeoTiffPolarFeeder Noaa20AtmsMirsJob NOAA20NucapsL2Job]
#sources += %w[Noaa18MirsL2 Noaa18GeoTiff_l1 Noaa18GeoTiff_l2]
#sources += ['Amsr2Level2']
#sources += %w[ViirsGeoTiff ViirsFeeder SNPPViirsFireJob NppViirsGeoTiffGM NppViirsGeoTiffGm2
#              NppViirsGeoTiffPolar NppViirsGeoTiffPolarFeeder AtmsMirsJob NucapsSdrJob]
#sources += %w[Noaa19MirsL2 Noaa19GeoTiff_l1 Noaa19GeoTiff_l2]
#sources += %w[MetopC_GeoTiff_l1 MetopC_GeoTiff_l2 MetopCMirsL2 MetopCNucaps]
sources += %w[MetopB_GeoTiff_l1 MetopB_GeoTiff_l2 MetopBMirsL2 MetopBNucaps]

pp sources

sources.each do |task|
  parent = task.to_sym
  task_sym = (task + 'ToDrive').to_sym
  steps[parrent] = Step.where(name: 'task').first
  steps[task_sym] = Step.where(name: task + 'ToDrive').first_or_create({
                                                                         command: 'to_google_drive.rb -t .  -d ~/go/bin/drive -p "NRT/PROD" {{job.input_path}}',
                                                                         queue: 'geotiff',
                                                                         producer: false,
                                                                         enabled: false,
                                                                         parent: steps[parrent]
                                                                       })
end
