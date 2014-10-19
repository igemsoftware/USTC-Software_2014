import Layout.ReminderManager;

import Layout.Reminder;

import flash.utils.ByteArray;

import Biology.LinkTypeInit;
import Biology.NodeTypeInit;

import Assembly.Canvas.Net;
import Assembly.Compressor.TextMapLoader;
import Assembly.Compressor.CompressedLine;
import Assembly.Compressor.CompressedNode;

import Style.TweenX;

public static const POSITION:int=0;


public static const ADD_NODE:int=1;
public static const DELETE_NODE:int=2;

public static const EDIT_NODE:int=3;

public static const ADD_LINE:int=4;
public static const DELETE_LINE:int=5;

public static const EDIT_LINE:int=6;


public static var currentStep:int=0;
public static var saveStep:int=0;
public static var OperationQueue:Array=[];

public static function get modified():Boolean{
	return currentStep!=saveStep;
}

////////Interface

public static function RestoreRecord():void{
	currentStep=0;
	saveStep=0;
	OperationQueue=[];
	
	iGemNet.setWindowLabel();
}

public static function RecordPosition(operateList:Array):void{
	
	OperationQueue.length=currentStep;
	OperationQueue[currentStep]=recordPosition(operateList);
	
	currentStep++;
	
	iGemNet.setWindowLabel();
	
}

public static function RecordNodeExistance(node:CompressedNode,status:int):void{
	
	OperationQueue.length=currentStep;
	
	OperationQueue[currentStep]=recordMultiNodeExistance([node],status);
	
	currentStep++;
	
	iGemNet.setWindowLabel();
	
}


public static function RecordMultiNodeExistance(arr:Array,status:int):void{
	
	OperationQueue.length=currentStep;
	
	
	OperationQueue[currentStep]=recordMultiNodeExistance(arr,status);
	
	currentStep++;
	
	iGemNet.setWindowLabel();
	
}

public static function RecordLineExistance(arrow:CompressedLine,status:int):void{
	OperationQueue.length=currentStep;
	
	OperationQueue[currentStep]=recordLineExistance(arrow,status);
	
	currentStep++;
	
	iGemNet.setWindowLabel();
	
}

public static function RecordNodeDetail(node:CompressedNode):void{
	
	OperationQueue.length=currentStep;
	
	OperationQueue[currentStep]=recordNodeDetail(node);
	
	currentStep++;
	
	iGemNet.setWindowLabel();
	
	
}

public static function RecordLineDetail(arrow:CompressedLine):void{
	
	OperationQueue.length=currentStep;
	
	OperationQueue[currentStep]=recordLineDetail(arrow);
	
	currentStep++;
	
	iGemNet.setWindowLabel();
	
}

///////////////functions


private static function recordPosition(operateList:Array):ByteArray{
	var _encodedMap:ByteArray=new ByteArray();
	_encodedMap.writeInt(POSITION);
	
	for each (var node:CompressedNode in operateList) {
		_encodedMap.writeUTF(node.ID);
		_encodedMap.writeDouble(node.remPosition[0]);
		_encodedMap.writeDouble(node.remPosition[1]);
	}
	
	return _encodedMap;
}

////////
private static function recordMultiNodeExistance(arr:Array,status:int):ByteArray{
	var _encodedMap:ByteArray=new ByteArray();
	
	var arrows:Object=new Object();
	var arrow:CompressedLine;
	var node:CompressedNode
	var nodes:int=0;
	_encodedMap.writeInt(status);
	
	if(status==DELETE_NODE){
		
		_encodedMap.writeInt(0);
		for each (node in arr) {
			
			_encodedMap.writeUTF(node.ID);
			_encodedMap.writeUTF(node.refID);
			_encodedMap.writeUTF(node.Name);
			
			_encodedMap.writeDouble(node.remPosition[0]);
			_encodedMap.writeDouble(node.remPosition[1]);
			
			_encodedMap.writeUTF(node.Type.Type);
			

			_encodedMap.writeUTF(node.detail);
		
			for each (arrow in node.Arrowlist) {
				arrows[arrow.ID]=arrow;
			}
			nodes++;
		}
		
		
		for each (arrow in arrows)
		{
			_encodedMap.writeUTF(arrow.ID);
			
			_encodedMap.writeUTF(arrow.Name);
			_encodedMap.writeUTF(arrow.refID);
			
			_encodedMap.writeUTF((arrow.linkObject[0] as CompressedNode).ID);
			_encodedMap.writeUTF((arrow.linkObject[1] as CompressedNode).ID);
			
			_encodedMap.writeUTF(arrow.Type.Type);
			
			_encodedMap.writeUTF(arrow.detail);
		}
		
		_encodedMap.position=4;
		_encodedMap.writeInt(nodes);
	}else{
		for each (node in arr) {	
			_encodedMap.writeUTF(node.ID);
		}
	}
	
	return _encodedMap;
}

private static function recordLineExistance(arrow:CompressedLine,status:int):ByteArray{
	var _encodedMap:ByteArray=new ByteArray();
	_encodedMap.writeInt(status);
	
	_encodedMap.writeUTF(arrow.ID);
	if(status==DELETE_LINE){
		_encodedMap.writeUTF(arrow.refID);
		_encodedMap.writeUTF(arrow.Name);
		
		_encodedMap.writeUTF((arrow.linkObject[0] as CompressedNode).ID);
		_encodedMap.writeUTF((arrow.linkObject[1] as CompressedNode).ID);
		
		_encodedMap.writeUTF(arrow.Type.Type);
		
		_encodedMap.writeUTF(arrow.detail);
	}
	return _encodedMap;
}

private static function recordNodeDetail(node:CompressedNode):ByteArray{
	var _encodedMap:ByteArray=new ByteArray();
	_encodedMap.writeInt(EDIT_NODE);
	
	_encodedMap.writeUTF(node.ID);
	_encodedMap.writeUTF(node.Name);
	_encodedMap.writeUTF(node.Type.Type);
	
	_encodedMap.writeUTF(node.detail);
	
	return _encodedMap;
}

private static function recordLineDetail(arrow:CompressedLine):ByteArray{
	var _encodedMap:ByteArray=new ByteArray();
	_encodedMap.writeInt(EDIT_LINE);
	
	_encodedMap.writeUTF(arrow.ID);
	_encodedMap.writeUTF(arrow.Name);
	_encodedMap.writeUTF(arrow.Type.Type);
	
	//for later version ,this will be added 
	//now added
	_encodedMap.writeUTF(arrow.detail);

	return _encodedMap;
}


//////////BACK STEP
public static function ForwardStep(e=null):void
{
	if(currentStep<OperationQueue.length){
		
		rewind();
		currentStep++;
		
		iGemNet.setWindowLabel();
		
		ReminderManager.remind("Redo");
	}
	
}

public static function BackStep(e=null):void{
	if(currentStep>0){
		currentStep--;
		rewind();
		
		iGemNet.setWindowLabel();
		
		ReminderManager.remind("Undo");
	}
}
public static function rewind():void{
	
	trace("currentStep:",currentStep);
	
	var encodedStep:ByteArray=OperationQueue[currentStep];
	
	encodedStep.position=0;
	var type:int=encodedStep.readInt();
	
	var tmpArr:Array=[];
	
	var node:CompressedNode;
	var arrow:CompressedLine;
	var edges:int;
	
	switch(type)
	{
		case POSITION:
		{
			
			while(encodedStep.bytesAvailable>0){
				node=Block_space[encodedStep.readUTF()];
				
				tmpArr.push(node);
				
				node.aimPosition[0]=encodedStep.readDouble();
				node.aimPosition[1]=encodedStep.readDouble();
				
			}
			OperationQueue[currentStep]=recordPosition(tmpArr);
			
			for each (node in tmpArr) 
			{
				node.remPosition[0]=node.aimPosition[0];
				node.remPosition[1]=node.aimPosition[1];
			}
			
			
			TweenX.GlideNodes(tmpArr);
			
			break;
		}
			
			
		case ADD_NODE: //to delete
		{
			
			while(encodedStep.bytesAvailable>0){
				node=Block_space[encodedStep.readUTF()];
				
				tmpArr.push(node);
				
			}
			
			OperationQueue[currentStep]=recordMultiNodeExistance(tmpArr,DELETE_NODE);
			
			for each (node in tmpArr) 
			{
				Net.DestoryNode(node);
			}
			
			break;
		}
			
		case DELETE_NODE: //to add
		{
			var nodes:int=encodedStep.readInt();
			for (var j:int = 0; j < nodes; j++) 
			{
				node=Net.loadCompressedBlock(encodedStep.readUTF(),encodedStep.readUTF(),encodedStep.readUTF(),encodedStep.readDouble(),encodedStep.readDouble(),encodedStep.readUTF(),encodedStep.readUTF());
				
				tmpArr.push(node);
			}
			
			
			while(encodedStep.bytesAvailable>0){
				Net.loadLink(encodedStep.readUTF(),encodedStep.readUTF(),encodedStep.readUTF(),Block_space[encodedStep.readUTF()],Block_space[encodedStep.readUTF()],encodedStep.readUTF(),encodedStep.readUTF());
			}
			OperationQueue[currentStep]=recordMultiNodeExistance(tmpArr,ADD_NODE);
			
			break;
		}
			
		case EDIT_NODE:{
			node=Block_space[encodedStep.readUTF()];
			
			OperationQueue[currentStep]=recordNodeDetail(node);
			
			node.Name=encodedStep.readUTF();
			node.Type=NodeTypeInit.BiotypeList[encodedStep.readUTF()];
			node.detail=encodedStep.readUTF();
			
			node.TextMap=TextMapLoader.generateTextMap(node.Name);
			
			Net.RedrawFocus(node);
			
			break;
		}
			
		case ADD_LINE: //to delete
		{
			
			arrow=Linker_space[encodedStep.readUTF()];
			
			OperationQueue[currentStep]=recordLineExistance(arrow,DELETE_LINE);	
			
			Net.DestoryLink(arrow);
			
			
			break;
		}
			
		case DELETE_LINE: //to add
		{
			
			arrow=Net.loadLink(encodedStep.readUTF(),encodedStep.readUTF(),encodedStep.readUTF(),Block_space[encodedStep.readUTF()],Block_space[encodedStep.readUTF()],encodedStep.readUTF(),encodedStep.readUTF());
			
			OperationQueue[currentStep]=recordLineExistance(arrow,ADD_LINE);	
			
			break;
		}
			
		case EDIT_LINE:{
			arrow=Linker_space[encodedStep.readUTF()];
			
			OperationQueue[currentStep]=recordLineDetail(arrow);
			
			arrow.Name=encodedStep.readUTF();
			
			arrow.Type=LinkTypeInit.LinkTypeList[encodedStep.readUTF()];
			
			arrow.detail=encodedStep.readUTF();
			
			Net.RedrawFocus(arrow);
			
			
			break;
		}
	}
}