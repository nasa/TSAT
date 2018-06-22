function blkStruct = slblocks
  % Specify that the product should appear in the library browser
  % and be cached in its repository
  Browser.Library = 'TSAT_Lib';
  Browser.Name    = 'TSAT';
  Browser(1).Choice = 1; 
  blkStruct.Browser = Browser;