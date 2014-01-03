
Animation anim;
AnimatedCode code;
Splitter split;
AnimatedArray arr;
Indicator minIndicator;
Indicator jIndicator;


void selectionSort(int arr[],int size){
    int minIdx;
    int tmp;
    for(int i=0;i<size;i++){
        anim.addStep();
        anim.addInstruction(0,SET,4);
        anim.addInstruction(3,SETBGCOLOUR,i,152,245,255);
        minIdx=i;
        anim.addStep();
        anim.addInstruction(0,SET,5);
        anim.addStep();
        anim.addInstruction(0,SET,6);
        anim.addInstruction(4,SET,i);
        anim.addInstruction(2,SET,i);
        anim.addInstruction(4,SETVISIBILITY,VISIBLE);
        anim.addInstruction(2,SETVISIBILITY,VISIBLE);
        for(int j=i;j<size;j++){
            anim.addStep();
            anim.addInstruction(0,SET,7);
            anim.addInstruction(4,SET,j);
            if(arr[j] < arr[minIdx]){
                anim.addStep();
                anim.addInstruction(2,SET,j);
                anim.addInstruction(0,SET,8);
                minIdx=j;
            }
        }
        if(minIdx!=i){
            anim.addStep();
            anim.addInstruction(4,SETVISIBILITY,HIDDEN);
            anim.addInstruction(2,SETVISIBILITY,HIDDEN);
            anim.addInstruction(3,SWAP,minIdx,i);
            anim.addInstruction(0,SET,11);
            tmp=arr[i];
            arr[i]=arr[minIdx];
            arr[minIdx]=tmp;
        }
        else{
            anim.addStep();
            anim.addInstruction(4,SETVISIBILITY,HIDDEN);
            anim.addInstruction(2,SETVISIBILITY,HIDDEN);
        }
        anim.addStep();
        anim.addInstruction(1,SET,i+1);
        anim.addInstruction(3,SETBGCOLOUR,i,189,252,201);  
    }
    anim.addStep();
    anim.addInstruction(1,SET,size);
    anim.addInstruction(3,SETALLBGCOLOUR,255,255,255);
    anim.addInstruction(2,SETVISIBILITY,HIDDEN);
    anim.addInstruction(4,SETVISIBILITY,HIDDEN);
    anim.addInstruction(0,SET,0);
}

void setup(){
    size(800,500);
    anim=new Animation(800, 500);
    code=new AnimatedCode("selection.txt", 480,80);
    anim.setColour(color(46,129,215));
    int [] array=new int[15];
    for(int i=0;i<15;i++){
        array[i]=int(random(1,99));
    }
    arr=new AnimatedArray(array,15,15,230);
    arr.hasBars_=true;
    arr.setBarOffset(-130);
    split=new Splitter("sorted","unsorted",color(0,255,0),color(255,0,0),15,30,15,290);
    minIndicator = new Indicator("minIdx",color(255,255,255),30,30,260);
    minIndicator.setColour(color(189,252,201));
    jIndicator = new Indicator("j",color(255,255,255),30,30,230);
    jIndicator.setColour(color(189,252,201));
    jIndicator.pointDown();
    jIndicator.setVisibility(HIDDEN);


    int tmp;
    anim.addObject(code);
    anim.addObject(split);
    anim.addObject(minIndicator);
    anim.addObject(arr);
    anim.addObject(jIndicator);
    selectionSort(array,15);
    anim.start();
}
void draw(){
    anim.draw();
}


