import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

class Hero {
  String name;
  Hero(this.name);
  Map<String, dynamic> toJson() => {'name': name};
}

@Component(
  selector: 'do-check',
  template: '''
    <div class="hero">
      <p>{{hero.name}} can {{power}}</p>

      <h4>-- Change Log --</h4>
      <div *ngFor="let chg of changeLog">{{chg}}</div>
    </div>
  ''',
  styles: [
    '.hero {background: LightYellow; padding: 8px; margin-top: 8px}',
    'p {background: Yellow; padding: 8px; margin-top: 8px}'
  ],
  directives: [coreDirectives],
)
class DoCheckComponent implements DoCheck {
  @Input()
  late Hero hero;
  @Input()
  late String power;

  bool changeDetected = false;
  List<String> changeLog = [];

  String oldHeroName = '';
  String oldPower = '';
  int oldLogLength = 0;
  int noChangeCount = 0;

  // #docregion ng-do-check
  ngDoCheck() {
    if (hero.name != oldHeroName) {
      changeDetected = true;
      changeLog.add(
          'DoCheck: Hero name changed to "${hero.name}" from "$oldHeroName"');
      oldHeroName = hero.name;
    }

    if (power != oldPower) {
      changeDetected = true;
      changeLog.add('DoCheck: Power changed to "$power" from "$oldPower"');
      oldPower = power;
    }

    if (changeDetected) {
      noChangeCount = 0;
    } else {
      // log that hook was called when there was no relevant change.
      var count = noChangeCount += 1;
      var noChangeMsg =
          'DoCheck called ${count}x when no change to hero or power';
      if (count == 1) {
        // add "no change" message
        changeLog.add(noChangeMsg);
      } else {
        // update last "no change" message
        changeLog[changeLog.length - 1] = noChangeMsg;
      }
    }

    changeDetected = false;
  }
  // #enddocregion ng-do-check

  void reset() {
    changeDetected = true;
    changeLog.clear();
  }
}

/***************************************/

@Component(
  selector: 'do-check-parent',
  templateUrl: 'do_check_parent_component.html',
  styles: ['.parent {background: Lavender}'],
  directives: [coreDirectives, formDirectives, DoCheckComponent],
)
class DoCheckParentComponent {
  late Hero hero;
  late String power;
  String title = 'DoCheck';
  @ViewChild(DoCheckComponent)
  DoCheckComponent? childView;

  DoCheckParentComponent() {
    reset();
  }

  void reset() {
    hero = Hero('Windstorm');
    power = 'sing';
    childView?.reset();
  }
}
