import peasy.PeasyCam;
import punktiert.math.Vec;
import punktiert.physics.*;

public class Particles {
  private VPhysics physics;
  private float accel;
  private float accelOffset;
  private PeasyCam cam;
  private float rand1;
  private float rand2;
  private float rand3;
  private int speed;

  public Particles(PeasyCam cam) {
  physics = new VPhysics();
  this.cam = cam;
  speed = 0;
  setupParticles();
  }
  
  public void speed() {
    speed = speed + 1;
  }

  public void setupParticles() {
     for (int i = 0; i < 1000; i++) {
       
      rand1 = random(-30,30);
      rand2 = random(-30,30);
      rand3 = random(-30,30);

    Vec pos = new Vec( 0,0, 0).jitter(1);
    Vec vel = new Vec(rand1,rand2,rand3);
    VBoid p = new VBoid(pos, vel);
    p.setRadius(20);

    p.swarm.setCohesionRadius(80);
    p.trail.setInPast(3);
    p.trail.setreductionFactor(2);
    physics.addParticle(p);

    p.addBehavior(new BCollision());

    physics.addSpring(new VSpringRange(p, new VParticle(), 300, 400, 0.0005f));
  } 
  }

  public void drawParticles() {
    while (speed > 0) {
    physics.update();
    cam.endHUD();
    for (int i = 0; i < physics.particles.size(); i++) {
      VBoid boid = (VBoid) physics.particles.get(i);
  
      strokeWeight(5);
      stroke(0,0,0,32);
      point(boid.x, boid.y, boid.z);
  
      if (frameCount > 400) {
        boid.trail.setInPast(100);
      }
      strokeWeight(1);
      stroke(200, 0, 0,32);
      noFill();
      beginShape();
      for (int j = 0; j < boid.trail.particles.size(); j++) {
        VParticle t = boid.trail.particles.get(j);
        vertex(t.x, t.y, t.z);
      }
      endShape();
    }
    cam.beginHUD();
    speed = speed - 1;
    }
  }

}
