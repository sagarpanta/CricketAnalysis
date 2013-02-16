$(document).ready(function(){
	var video = document.querySelector('#video');
	var canvas = document.querySelector('#canvas');
		
	if (video != null){
		var ctx = canvas.getContext('2d');
		var localMediaStream = null;
		var fs = null; // file system 
		var error = 0; // if file system API error
		var _stop = false; // if user presses stop
		var frames = 0; // index for the image files (files0 files1 etc)
		var _files = []; // store the path of the images recoreded

		 
		 
		function errorHandler(err){
		error =1 ;
		 var msg = 'An error occured: ';
			switch (err.code) {
				case FileError.NOT_FOUND_ERR:
					msg += 'File or directory not found';
					break;
		 
				case FileError.NOT_READABLE_ERR:
					msg += 'File or directory not readable';
					break;
		 
				case FileError.PATH_EXISTS_ERR:
					msg += 'File or directory already exists';
					break;
		 
				case FileError.TYPE_MISMATCH_ERR:
					msg += 'Invalid filetype';
					break;
		 
				default:
					msg += 'Unknown Error';
					break;
			};
		 
		 console.log(msg);
		};
		 
		var stopRec = function() {
			// stop video recording
			_stop = true;
			video.pause();
			//var video = document.querySelector('#video');
			//localMediaStream.stop();
			//localMediaStream = null;
		}
		 
		
		//stop.addEventListener('click', stopRec, false);
		
		function pad(str, max) {
			return str.length < max ? pad("0" + str, max) : str;
		}
		
		 
		var initDirectory = function(fs) {
			fs.root.getDirectory('Video', {create: true, exclusive:false}, function(dirEntry) {
				console.log('You have just created the ' + dirEntry.name + ' directory.');
				
				var page = $('#analysis_page').html();
				if(page!= undefined){
					document.getElementById('replay').addEventListener('click', replayVideo, false);
				}
		 
				fs.root.getDirectory('Video', {}, function(dirEntry){
				  var dirReader = dirEntry.createReader();
				  dirReader.readEntries(function(entries) {
					for(var i = 0; i < entries.length; i++) {
					  var entry = entries[i];
					  if (entry.isDirectory){
						console.log('Directory: ' + entry.fullPath);
					  }
					  else if (entry.isFile){
						console.log('File: ' + entry.fullPath);
					  // remove comment to delete all files
						_files.push(entry.fullPath);
						frames = parseInt(entry.fullPath[entry.fullPath.length-1]);
					  }
					}
				 
				  }, errorHandler);
				}, errorHandler);
			}, errorHandler);
		}
		 
		
		var writeToFile = function(name, data) {
		 
			fs.root.getFile('Video/' + name, {create: true, exclusive: true}, function(fileEntry) {
				console.log('A file ' + fileEntry.name + ' was created successfully.');
					fs.root.getFile('Video/' + fileEntry.name, {create: false}, function(fileEntry) {
					fileEntry.createWriter(function(fileWriter) {
						console.log('writing to ' + 'Video/' + fileEntry.name)
						_files.push('Video/' + fileEntry.name);

						window.URL = window.URL || window.webkitURL;
						var data_arr = new Array();
						data_arr.push(data);
						var bb = new Blob(data_arr, {type: 'text/css'});

						fileWriter.write(bb);
					}, errorHandler);
				}, errorHandler);
			}, errorHandler);
		}
		 
		 
		var initFs = function(filesys) {
			fs = filesys;
			setTimeout(initDirectory(fs), 500);
		}
		 
		var frameimages = [];
/*		 
		var replayVideo = function(idx) {
			// reads through all the images and show them (image path stored in _files)
			_stop = true;
			//video.pause();
			//video.style.display = 'none'; // hide the video to see the recording
			if(idx.clientX) idx = 0;
			if(_files[idx] === undefined) {
				alert('nothing to play');
				return;
			}
			var img = document.getElementById('replay-screen');

			fs.root.getFile(_files[idx], {}, function(fileEntry) {
				fileEntry.file(function(file) {
					var reader = new FileReader();
					reader.onloadend = function(e) {
							img.src = this.result;
						if(++idx < _files.length) 
							setInterval(replayVideo(idx), 2*1000); // y u no work !?
					};
					reader.readAsText(file);
				}, errorHandler);
			}, errorHandler);
		}
		 
		var readFile = function(filename) {
			fs.root.getFile(filename, {}, function(fileEntry) {
				fileEntry.file(function(file) {
					var reader = new FileReader();
					reader.onloadend = function(e) {
						console.log(this.result);
					};
					reader.readAsText(file);
				}, errorHandler);
			}, errorHandler);
		}
*/		
		$(document).on('click', '#stop', function(){
			// stop video recording
			_stop = true;
			video.pause();
			//var video = document.querySelector('#video');
			//localMediaStream.stop();
			//localMediaStream = null; 
		});
		 
		$(document).on('click', '#delete-replay', function(){ 
			fs.root.getDirectory('Video', {}, function(dirEntry){
			  var dirReader = dirEntry.createReader();
			  dirReader.readEntries(function(entries) {
				var temp = [];
				if(!entries.length) alert('nothing to delete');
				for(var i = 0; i < entries.length; i++) {
				  var entry = entries[i];
				  if (entry.isFile){
					 fs.root.getFile(entry.fullPath, {create: false}, function(fileEntry) {
					  fileEntry.remove(function() {
						console.log('File successufully removed.');
					  }, errorHandler);
					}, errorHandler);
				  }
				}
			 
			  }, errorHandler);
			}, errorHandler);
		});
		 
		
	

		navigator.webkitGetUserMedia({video:true}, function(stream) {
			console.log('after');
			video.src = window.webkitURL.createObjectURL(stream);
			video.controls = true;
			localMediaStream = stream;
			video.pause();
		
			}, function(){
				alert('no support for webkitGetUserMedia()');
		});
		
		//Finds y value of given object
		function findPos(obj) {
			var curtop = 0;
			if (obj.offsetParent) {
				do {
					curtop += obj.offsetTop;
				} while (obj = obj.offsetParent);
			return [curtop];
			}
		}

		
		var sendMess = function(){
			if (video.paused == true){
				_stop = false;
				video.style.display = 'block';
				var back = document.getElementById('canvas');
				var backcontext = back.getContext('2d');

				cw = 240;
				ch = 400;
				back.width = cw;
				back.height = ch;
				draw(video, backcontext, cw, ch);
				
				var id = $('#id').html();
				$('#id').html(parseInt(id)+1);
				
				var clientkey = $('#clientkey').html();
				
				var _filename = pad(clientkey,4)+'_'+pad(id,6)+'_';
				console.log('this is the filename ' + _filename);
				
				function draw(v, bc, w, h){
					 bc.drawImage(v, 0, 0, w, h);
						
						var stringData=canvas.toDataURL();
						if(fs !== null) {
							writeToFile(_filename + pad(frames.toString(),10), stringData);
							frames = frames + 1;
						}
						if(!_stop) 
							setTimeout(function(){ draw(v, bc, w, h); }, 10); // the timeout here decides video rec framerate
				}
			}
			else{
				_stop = true;
				frames = 1;
				window.scroll(0,findPos(document.getElementById("tournament")));
			}
		};
		
		document.getElementById('video').addEventListener('click', sendMess, false);	
		

		window.requestFileSystem  = window.requestFileSystem || window.webkitRequestFileSystem;
		//window.requestFileSystem(window.TEMPORARY, 10*1024*1024, initFs, errorHandler);
		window.webkitStorageInfo.requestQuota(PERSISTENT, 1024*1024*1024, function(grantedBytes) {
			window.requestFileSystem(PERSISTENT, grantedBytes, initFs, errorHandler);
		});
	
	
	
	}
});