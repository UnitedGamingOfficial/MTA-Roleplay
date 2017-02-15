function lazyQuery(message)
	local filename = "/lazyqueries.log"

	local file = createFileIfNotExists(filename)
	local size = fileGetSize(file)
	fileSetPos(file, size)
	fileWrite(file, message .. "\r\n")
	fileFlush(file)
	fileClose(file)
	
	return true
end

function createFileIfNotExists(filename)
	return fileExists(filename) and fileOpen(filename) or fileCreate(filename)
end