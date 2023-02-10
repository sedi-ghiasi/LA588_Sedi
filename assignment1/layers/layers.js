var wms_layers = [];

var format_multivariant_0 = new ol.format.GeoJSON();
var features_multivariant_0 = format_multivariant_0.readFeatures(json_multivariant_0, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_multivariant_0 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_multivariant_0.addFeatures(features_multivariant_0);
var lyr_multivariant_0 = new ol.layer.Vector({
                declutter: true,
                source:jsonSource_multivariant_0, 
                style: style_multivariant_0,
                interactive: true,
    title: 'multivariant<br />\
    <img src="styles/legend/multivariant_0_0.png" /> <br />\
    <img src="styles/legend/multivariant_0_1.png" /> 1<br />\
    <img src="styles/legend/multivariant_0_2.png" /> 2<br />\
    <img src="styles/legend/multivariant_0_3.png" /> 3<br />\
    <img src="styles/legend/multivariant_0_4.png" /> 4<br />\
    <img src="styles/legend/multivariant_0_5.png" /> 5<br />\
    <img src="styles/legend/multivariant_0_6.png" /> 6<br />'
        });

lyr_multivariant_0.setVisible(true);
var layersList = [lyr_multivariant_0];
lyr_multivariant_0.set('fieldAliases', {'SOURCE_ID': 'SOURCE_ID', 'grid_treer': 'grid_treer', 'grid_treeh': 'grid_treeh', 'grid_FAR': 'grid_FAR', 'grid_Build': 'grid_Build', 'Shape_Leng': 'Shape_Leng', 'Shape_Area': 'Shape_Area', 'CLUSTER_ID': 'CLUSTER_ID', 'IS_SEED': 'IS_SEED', });
lyr_multivariant_0.set('fieldImages', {'SOURCE_ID': 'TextEdit', 'grid_treer': 'TextEdit', 'grid_treeh': 'TextEdit', 'grid_FAR': 'TextEdit', 'grid_Build': 'TextEdit', 'Shape_Leng': 'TextEdit', 'Shape_Area': 'TextEdit', 'CLUSTER_ID': 'TextEdit', 'IS_SEED': 'TextEdit', });
lyr_multivariant_0.set('fieldLabels', {'SOURCE_ID': 'no label', 'grid_treer': 'inline label', 'grid_treeh': 'inline label', 'grid_FAR': 'inline label', 'grid_Build': 'inline label', 'Shape_Leng': 'no label', 'Shape_Area': 'no label', 'CLUSTER_ID': 'header label', 'IS_SEED': 'no label', });
lyr_multivariant_0.on('precompose', function(evt) {
    evt.context.globalCompositeOperation = 'normal';
});