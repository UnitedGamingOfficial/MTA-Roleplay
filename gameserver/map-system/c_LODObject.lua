function setAllLODDistances()
	for key, value in pairs(getElementsByType("object", getResourceRootElement())) do
		local model = getElementModel(value)
		engineSetModelLODDistance(model, 300)
	end
end
addEventHandler("onResourceStart", getRootElement(), setAllLODDistances)