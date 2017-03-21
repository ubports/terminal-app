function createComponentInstance(component, parent, properties, callback) {
    var incubator;
    if (component.status == Component.Ready) {
        incubator = component.incubateObject(parent, properties, Qt.Synchronous);

        function objectCreated(status) {
            if (status == Component.Ready && callback != null) {
                callback(incubator.object);
            }
        }
        incubator.onStatusChanged = objectCreated;
        incubator.forceCompletion();
    } else if (component.status == Component.Error) {
        console.log("Error loading component:", component.errorString());
    }
}
