class splash {
    float opacity;
    float r = 5;

    // constructor
    splash(){
        opacity = 255;
    }

    void update(){
        newSplash();
    }

    void newSplash(){
        ellipseMode(CENTER);
        fill(125, opacity);
        ellipse(mouseX, mouseY, r, r);
        r = r + 20;
        opacity = opacity - 20;
        if(opacity < 0){
            onKill();
        }
    }

    void onKill(){
        for(int i = 0; i < splashAni.size(); i++){
            splashAni.remove(i);
    }
    }
}
