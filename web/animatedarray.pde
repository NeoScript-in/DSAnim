void drawBar(int idx,float value,float maxHeight, int yOffset, color co,int sz,int posX,int posY){
	stroke(co);
	fill(co);
	int ystart=posY+yOffset;
	int xstart=posX+idx*sz+sz/2-10;
	value=value/99;
	rect(xstart,ystart+(maxHeight-(value*maxHeight)),20,value*maxHeight);
}
class AnimatedArray extends AnimationObject{
	int [] data_;
	boolean [] isEmpty_;
	color [] dataColours_;
	color [] squareColours_;
	int [] gap_;
	int cap_;
	int sz_;
	int state_;
	int sqsz_;
	int to_;
	int from_;
	float stateStartTime_;
	float animationDuration_;
	boolean hasBars_;
	int barOffset_;
	AnimationInstruction ai_;
	float maxHeight_;
	int moveX_;
	int moveY_;
	int moveIdx_;
	int moveVal_;

	AnimatedArray(int [] data,int sz,int x,int y){
		super(x,y);
		cap_=MAXARRAY;
		sz_=sz;
		sqsz_=30;
		data_ = new int [cap_];
		isEmpty_= new boolean[cap_];
		dataColours_=new color[cap_];
		squareColours_=new color[cap_];
		gap_ = new int[cap_];
		state_=STABLE;
		animationDuration_=500;   //1000 millis = 1 sec
		for(int i=0;i<sz;i++){
			data_[i]=data[i];
			gap_[i]=0;
			dataColours_[i]=color(0);
			squareColours_[i]=color(255);
			isEmpty_[i]=false;
		}
		for(int i=sz_;i<cap_;i++){
			data_[i]=0;
			gap_[i]=0;
			dataColours_[i]=color(0);
			squareColours_[i]=color(255);
			isEmpty_[i]=true;
		}
		maxHeight_=100;
		barOffset_ = 50;
	}
	AnimatedArray(int cap,int x, int y){
		super(x,y);
		cap_=cap;
		sz_=cap;
		sqsz_=30;
		data_ = new int [cap_];
		isEmpty_= new boolean[cap_];
		dataColours_=new color[cap_];
		squareColours_=new color[cap_];
		gap_ = new int[cap_];
		state_=STABLE;
		animationDuration_=500;   //1000 millis = 1 sec
		for(int i=0;i<cap_;i++){
			dataColours_[i]=color(0);
			squareColours_[i]=color(255);
			isEmpty_[i]=true;
			gap_[i]=0;
		}
		fillRandom();
		maxHeight_=100;
	}
	void process(AnimationInstruction ai){
		ai_=ai;
		switch(ai.instruction_){
			case SWAP:
				state_=SWAP;
				from_=ai.a_;
				to_=ai.b_;
				stateStartTime_=millis();
				break;
			case MOVE:
				state_=MOVE;
				from_=ai.a_;
				to_=ai.b_;
				stateStartTime_=millis();
				break;
			case SETFONTCOLOUR:
				ai.setCompleted(true);
				dataColours_[ai.a_]=color(ai.b_,ai.c_,ai.d_);
				break;				
			case SETBGCOLOUR:
				ai.setCompleted(true);
				squareColours_[ai.a_]=color(ai.b_,ai.c_,ai.d_);
				break;
			case SETALLBGCOLOUR:
				ai.setCompleted(true);
				for(int i=0;i<sz_;i++){
					squareColours_[i]=color(ai.a_,ai.b_,ai.c_);
				}
				break;
			case SETALLFONTCOLOUR:
				ai.setCompleted(true);
				for(int i=0;i<sz_;i++){
					dataColours_[i]=color(ai.a_,ai.b_,ai.c_);
				}
				break;
			case MOVEFROM:
				state_=MOVEFROM;
				moveIdx_=ai.a_;
				moveX_=ai.b_;
				moveY_=ai.c_;
				stateStartTime_=millis();
				isEmpty_[moveIdx_]=true;
				break;				
			case MOVETO:
				state_=MOVETO;
				moveVal_=ai.a_;
				moveIdx_=ai.b_;
				moveX_=ai.c_;
				moveY_=ai.d_;
				stateStartTime_=millis();
				break;
			case ADDGAP:
				gap_[ai.a_]=sqsz_/2;
				ai.setCompleted(true);
				break;
			case SETFONTCOLOURINRANGE:
				ai.setCompleted(true);
				for(int i=ai.a_;i<ai.b_;i++){
					dataColours_[i]=color(ai.c_,ai.d_,ai.e_);
				}
				break;
			}
	}
	void drawMoveFrom(){
		drawStable();
		float currTime=millis();
		if(currTime - stateStartTime_ < animationDuration_){

			float startX=((x_+moveIdx_*sqsz_)+(0.5*sqsz_));
			float startY=y_+sqsz_*0.5+5;
			float len=dist(0,0,startX,startY);
			float vX=(startX-moveX_)/len*10;
			float vY=(startY-moveY_)/len*10;
			float t=(currTime-stateStartTime_)/animationDuration_;
			float cpX=(startX+moveX_)/2-vY;
			float cpY=(startY+moveY_)/2+vX;
		    float x=bezierPoint(startX,cpX,cpX,moveX_,t);
		    float y=bezierPoint(startY,cpY,cpY,moveY_,t);
		    fill(dataColours_[moveIdx_]);
		    text(data_[moveIdx_],x,y);
		}
		else{
			ai_.setCompleted(true);
	    	state_=STABLE;

		}


	}
	void drawMoveTo(){
		drawStable();
		float currTime=millis();
		if(currTime - stateStartTime_ < animationDuration_){

			float startX=((x_+moveIdx_*sqsz_)+(0.5*sqsz_));
			float startY=y_+sqsz_*0.5+5;
			float len=dist(0,0,startX,startY);
			float vX=(startX-moveX_)/len*10;
			float vY=(startY-moveY_)/len*10;
			float t=(currTime-stateStartTime_)/animationDuration_;
			float cpX=(startX+moveX_)/2-vY;
			float cpY=(startY+moveY_)/2+vX;
		    float x=bezierPoint(moveX_,cpX,cpX,startX,t);
		    float y=bezierPoint(moveY_,cpY,cpY,startY,t);
		    fill(dataColours_[moveIdx_]);
		    text(moveVal_,x,y);		}
		else{
			data_[moveIdx_]=moveVal_;
			isEmpty_[moveIdx_]=false;
			ai_.setCompleted(true);
	    	state_=STABLE;
	    	drawStable();
		}


	}
	void drawBars(){
    	for(int i=0;i<sz_;i++){
      		if(!isEmpty_[i]){
        		drawBar(i,data_[i],maxHeight_,barOffset_,#FFFFFF,sqsz_,x_,y_);
		    }
	    }   
	}
	void drawStable(){
		int gap=0;
		for(int i=0;i<sz_;i++){
			if(isEmpty_[i] != true){
				drawSqWithNum(data_[i],dataColours_[i],squareColours_[i],sqsz_,gap+x_+i*sqsz_,y_);
			}
			else{
				drawSquare(sqsz_,squareColours_[i],gap+x_+i*sqsz_,y_);
			}
			gap+=gap_[i];
		}
	}
	void drawSwap(){
		float currTime=millis();
		if(currTime - stateStartTime_ < animationDuration_){
	    	for(int i=0;i<sz_;i++){
    	    	if(i==to_ || i==from_){
        	  		drawSquare(sqsz_,squareColours_[i],gap+x_+i*sqsz_,y_);
        		}
       			else{
          			drawSqWithNum(data_[i],dataColours_[i],squareColours_[i],sqsz_,gap+x_+i*sqsz_,y_);
        		}
        		gap+=gap_[i];
	      	}
	      	float t=(currTime-stateStartTime_)/animationDuration_;
	      	float start = x_+(from_+0.5)*sqsz_;
	      	float end = x_+(to_+0.5)*sqsz_;
	      	float half= (start+end)/2;
	      	float height=50;
	      	float x=bezierPoint(start,half,half,end,t);
	      	float y=bezierPoint(y_+(sqsz_*0.5)+5,y_-height+5,y_-height+5,y_+(sqsz_*0.5)+5,t);
	      	fill(dataColours_[from_]);
	      	text(data_[from_],x,y);	

	      	x=bezierPoint(end,half,half,start,t);
	      	y=bezierPoint(y_+(sqsz_*0.5)+5,y_+height+5,y_+height+5,y_+(sqsz_*0.5)+5,t);
	      	fill(dataColours_[to_]);
	      	text(data_[to_],x,y);
	    }
	    else{
	    	int tmp=data_[to_];
	    	data_[to_]=data_[from_];
	    	data_[from_]=tmp;
	    	ai_.setCompleted(true);
	    	state_=STABLE;
	    	drawStable();
	    }
	}
	void drawMove(){
		float currTime=millis();
		if(currTime - stateStartTime_ < animationDuration_){
	    	for(int i=0;i<sz_;i++){
    	    	if(i==to_ || i==from_){
        	  		drawSquare(sqsz_,squareColours_[i],x_+i*sqsz_,y_);
        		}
       			else{
          			drawSqWithNum(data_[i],dataColours_[i],squareColours_[i],sqsz_,x_+i*sqsz_,y_);
        		}
	      	}
	      	float t=(currTime-stateStartTime_)/animationDuration_;
	      	float start = x_+(from_+0.5)*sqsz_;
	      	float end = x_+(to_+0.5)*sqsz_;
	      	float half= (start+end)/2;
	      	float height=50;
	      	float x=bezierPoint(start,half,half,end,t);
	      	float y=bezierPoint(y_+(sqsz_*0.5),y_-height+9,y_-height+9,y_+(sqsz_*0.5)+9,t);
	      	fill(dataColours_[from_]);
	      	text(data_[from_],x,y);	

	    }
	    else{
	    	data_[to_]=data_[from_];
	    	isEmpty_[from_]=true;
	    	isEmpty_[to_]=false;
	    	ai_.setCompleted(true);
	    	state_=STABLE;
	    	drawStable();
	    }
	}
	void draw(){
		switch(state_){
			case STABLE:
				drawStable(); break;
			case SWAP:
				drawSwap(); break;
			case MOVETO:
				drawMoveTo(); break;
			case MOVEFROM:
				drawMoveFrom(); break;
			case MOVE:
				drawMove(); break;		
		}
		if(hasBars_){
			drawBars();
		}
	}
	void fillRandom(){
    	for(int i=0;i<cap_;i++){
      		data_[i]=int(random(1,99));
    	}
   		sz_=cap_;
  	}
  	void reset(int [] array,int sz){
    	for(int i=0;i<sz;i++){
      		data_[i]=array[i];
    	}
   		sz_=sz;
  	}
  	void setBarOffset(int offset){
  		barOffset_=offset;
  	}
};