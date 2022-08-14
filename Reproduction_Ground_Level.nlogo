globals [%fecundity]

turtles-own [
  age                ;; each person has an age
  coupled?           ;; If true, the person is in a sexually active couple.
  couple-length      ;; How long the person has been in a couple
  commitment         ;; How long the person will stay in a couple-relationship.
  coupling-tendency  ;; How likely the person is to join a couple.
  partner            ;; The person that is our current partner in a couple.
  nb-of-children     ;; how many children they have
  ressources         ;; the level of ressources they have: ressources are set at setup for initial turtles and then inherited from mother and father
  mother
  father             ;; fahter and mother are set at turtle birth, initial turtles have none: again we define these roles as linked to gender in our model to reflect
  ;; biological constraints: it could be different in other models especially if we change biological and societal mechanisms and introduce others like cloning

]

;;;;
;;;SETUP PROCEDURE
;;;;

to setup
  clear-all
  setup-people
  reset-ticks

end



to setup-people
  ;; creating a separate setup for male and female and not just differentiate them by shape may be computationally a bit heavier but enables later to differentiate their behaviors
  ;; which can add very interesting factors for their coupling and reproduction dynamics.
  ;; For example, we could differentiate their coupling or commitment tendency based on their age and gender,
  ;; we could also see the consequences of setting different menopause and andropause age, different adult-age, or different ressources for each gender.
  ;; In this model, turtles reproduce when the conditions are gathered for them to do so, but their is no specific "incentive mechanism" or goal modelled for agent to fulfill
  ;; An improvement of the model would be to input intencives and life goals in agent's behavior and then, modify their parameters by gender and see how it affects their behavior.
  ;; For example, how a society willing to make as many children as possible reacts to a female rate of only 40% ? (which can also remind some existing situations).
  ;; Another example would be : how would a society desiring children adapt their comittment behaviors depending on whether you are in a dense /populated society or a low populated one.

  ;; In these examples, then one could make some parameters : average comittments, max-children, coupling tendency etc. become variables and observe how they evolve.

 create-turtles initial-people * female-rate
  [ setxy random-xcor random-ycor
    set coupled? false
    set partner nobody
    set age adult-age + 1 ;; initial turtles are just born adults
    set size 1
    set shape "female"
    set color green
    set mother nobody ;; first turtles are just born already adult
    set father nobody
    set nb-of-children 0
    assign-commitment
    assign-coupling-tendency
    assign-ressources
  ]

  create-turtles initial-people * (1 -  female-rate)
  [setxy random-xcor random-ycor
    set coupled? false
    set partner nobody
    set age adult-age + 1
    set size 1
    set shape "male"
    set color orange
    set mother nobody
    set father nobody
    set nb-of-children 0
    assign-commitment
    assign-coupling-tendency
    assign-ressources]


end

;; couple parametrization :


to assign-commitment  ;; turtle procedure
  set commitment random-near average-commitment
end

to assign-coupling-tendency  ;; turtle procedure
  set coupling-tendency random-near average-coupling-tendency
end


;; assign ressources with a random rule: this rule makes an inequal society, one could modify the model to make another financial ressources repartition profile

to assign-ressources ;; turtle procedure
  set ressources random  1000
end


;; helper functions

to-report random-near [center]  ;; turtle procedure
  let result 0
  repeat 40
    [ set result (result + random-float center) ]
  report result / 20
end



;; GO procedures ;;

to go
  ask turtles
    [set age age + 1 ] ; people age at each tick]

  ask turtles ;; policy for updating children ressources
  [ if age < adult-age [children-education] ]

  ask turtles ;; policy for turning children into adults
      [if age = adult-age
        [if shape = "female" [ set color green ]
        if shape = "male"  [set color orange ]
         set size 1
          if ressources < cost-of-child [die] ;; the adult age is the time the test is made on your ressources
         set mother nobody
         set father nobody ;; life being hard, your parents abandon their role as parent once you reach the adult-age
        ] ]


  ask turtles
    [ if not coupled?
        [ move ] ]
  ;; Male are always the ones to initiate mating.  This is a purely arbitrary choice which makes the coding easier: one party has to make the move:
  ;; if we make 2 variables : righties (like in the HIV model) + male / female: then the probablities of coupling become even smaller .
  ;;  The model could also make women initiate the move but we "split" repsonsiblities and women are, already, to be the ones to carry child ("hatch"), from obvious biological constraints.

  ask turtles
    [ if not coupled? and age > adult-age and shape = "male" and (random-float 1.0 < coupling-tendency)
        [ heterosexual-couple ] ] ;; here only heterosexual couples are considered. A more complex model would encompass
  ;; other coupling preference and reproduction behaviors like surrogacy, assisted procreation or adoption

  ask turtles
      [if coupled?
        [set couple-length couple-length + 1
        widowhood] ] ;; a relationship also ages, and when one partner dies, the other has to be set free fot the model to continue running: which is the purpose of the widowhood function.

  ask turtles [ if shape = "female" [reproduce ]] ;; in our model we define a biological constraints: only female can "reproduce": or at least bear children.
  ;; If this constraint is not here, male turtle also start to hatch and if there is not coupling constraint to this: it becomes a basic modelisation of cloning, which brings very very high reproducibility rates
  ;; probably the highest amon all models.
  ask turtles [ breakup]
  ask turtles [ death ]
  tick

end

to move  ;; turtle procedure
  ;;rt random-float 360
  ;;fd 1
  rt random 50
  lt random 50
  fd 1
end

to reproduce ;; turtle procedure
  ;; give birth to a new human : with some parameters set at birth: like gender, coupling tendencies and ressources that are directly implied from parents ressources.
  ;; Our model is a very inequal one where turtles inherit their ressources and cannot change these during their lifetime, except through associating with a wealthier individual and only during the time of their relationship.
  ;; Let's say our model is closer in its rules and dynamics to those of the first human societies ( or at least some like ancient Chinese or european ones) since it is easier computationnally and in the architecture
  ;; to go form these first, "simplified" building blocks and then proceed creating more differentiated and sophisticated mechanisms on top of it, whether societal or economic.
  ;; We do not want to ignore the diversity in social or economics behaviors of ancient societies but simply want to make the model start somewhere where it can then evolve in the best manner computationnally.
  ;; One would remark though, that financial ressources are given randomnly to male and female without differentiation from gender, creating a society with initially as much rich men as rich women
  ;; From there on, one could also extend the model to observe how these financial factors could be affected, gender by gender, in the postive or negative direction by different reproductive mechanisms:
  ;; -would it make male poorer to have to support most of the cost of children, would it lengthen their committment duration?
  ;; Would androgyny (female having several male partners) gather more steam in a wealthy, poor or very poor society ? In an equal or unequal one ?

  ;; let happy-mother myself
  let happy-father partner
  let direct-siblings random 3

  if coupled? and adult-age < age and age < menopause_andropause and nb-of-children < max-children and couple-length >= 2 ;; conditions on the mother part
  ;; couple-length must be at least 2 years to make children

  [if [age] of partner < menopause_andropause and [age] of partner > adult-age and [nb-of-children] of partner < max-children ;; conditions on the father part

  ;; here we do not put a condition on a cost of child vs ressources of parents to have a kid :
    ;; parents do have their children but when these children reach adult age, if they do not have enough ressources they die
    ;; this reflect the fact that some families can bear many children but under bad circunstances, these children die (this would be a "long range" equivalent
    ;; to infantile mortality which would take into account not only the situation of the child at birth but also what happens during the childhood: if couple separate -> ressources decrease, etc.
    [ hatch direct-siblings [  ;; people can have at random either one kid, some twins or triplets : one can expand the model to change this and represent a different biological reality
      rt 1
      fd 2
      set size 0.7
      set age 0
      set coupled? false
      set color white
      set mother myself ;; this is needed for the code : women do not clone themselves
      set father happy-father

      ifelse random-float 1.0 < female-rate
        [ set shape "female" ]
        [ set shape "male" ]

      assign-commitment
      assign-coupling-tendency

      ;; assign child ressources:
      ;; ressources come 50% from the mother and 50% from the father. Then we could have 2 versions: either you split this amount by nb of babies in the same pregnancy which would disadvantage the twins and triplets
      ;; or, version 2:  set the same ressource to each child.
      ;; In our model we dont want to disadvantage numerous families as they can be stopped by a max nb of children in any case.
      ;; As financial ressources are set at random : preventing people to have children based on their ressources would go back to a random game (or random association game)
      ;; here we want to put constraints on the nb of children (or at least nb of children reaching adult age) based on coupling tendencies:
        ;; - necessary to be in a couple to make children
        ;; - necessary to be in a couple for long enough to make children
        ;; - if the couple split during the childhood, the mother abandons the child and the child ressources become only the father's half

        ;; set ressources (0.5 * [ressources] of mother + 0.5 * [ressources] of father) / direct-siblings ;; assignation of ressources 1 st version


        set ressources (0.5 * [ressources] of mother + 0.5 * [ressources] of father) ;;  assignation of ressources 2nd version

        ;; one of the consequence of "letting children without enough ressources die" only at reaching adult age is that some low income families will raise children which are dommed :
        ;; and then, the father and mother in these families might be blocked by max nb of children: so very monogamous relationships lasting 35 years with "doomed" children make
        ;; indivuals "loose" many years in "infertile relationships" as children eventually die and reduce over reproductilibity rate.
        ;; This is one of the unforeseen consequence that would, for exemple, be use to observe whether strict monogamy pauses a threat to very poor societies whith high infantile mortality.

      move]

    right random 360
    set nb-of-children nb-of-children + 1
    ask partner [set nb-of-children nb-of-children + 1]
  ] ]
end

;; we add a widowhood function in order to detach turtles from a dying partner
;; an extension of this could be a widowhood period during which people do not recouple
to widowhood
  if coupled?
  [
  if (age >= life-expectancy - 1) or ([age] of partner) >= (life-expectancy - 1)
  [uncouple]
  ]
end

to death     ;; turtle procedure
  ;; die if you exceed the life expenctancy
  if age >= life-expectancy [ die ]

end

to children-education ;; turtle procedure
  ;; first rule is : if your parents are dead, they you die

  if mother != nobody and ([age] of mother) = life-expectancy - 1 [set mother nobody] ;; say farewell to mum
  if father != nobody and ([age] of father) = life-expectancy - 1 [set father nobody] ;; say farewell to dad

  ;; if the parents relationship ends: the mother abandons the child and the father has to bear it alone.
  ;; we still keep track in the variable nb of children though to be able to make a mean of all turtles at the end
  if mother != nobody and father != nobody [if [partner] of mother != father
                                   [ set ressources  (0.5 * [ressources] of father)
                                    set mother nobody] ]

  if mother = nobody and father = nobody [die] ;; if both parents dies while you are underaged you die


end

to heterosexual-couple
  let potential-partner one-of (turtles-at -1 0)
    with [not coupled? and age > adult-age and shape = "female"]

  if potential-partner != nobody
    [ if random-float 1.0 < [coupling-tendency] of potential-partner
      [ set partner potential-partner
        set coupled? true
        ask partner [ set coupled? true ]
        ask partner [ set partner myself ]
        move-to patch-here ;; move to center of patch
        ask potential-partner [move-to patch-here] ;; partner moves to center of patch
        set pcolor gray - 3
        ask (patch-at -1 0) [ set pcolor gray - 3 ] ] ]
end


to breakup
  if coupled?
    [ if (couple-length > commitment) or
      ([couple-length] of partner) > ([commitment] of partner)
      [uncouple]
  ]
end


to uncouple  ;; turtle procedure
  set coupled? false
  set couple-length 0
  ask partner [ set couple-length 0 ]
  set pcolor black
  ask (patch-at -1 0) [ set pcolor black ]
  ask (patch-at 1 0) [ set pcolor black ]
  ask partner [ set partner nobody ]
  ask partner [ set coupled? false ]
  set partner nobody
end



to check-sliders
  if (average-commitment != average-commitment)
    [ ask turtles [ assign-commitment ]
      set average-commitment average-commitment ]

  if (average-coupling-tendency != average-coupling-tendency)
    [ ask turtles [ assign-coupling-tendency ]
      set average-coupling-tendency average-coupling-tendency ]

end


to-report fecundity
 ;; as we counted the nb of children for men as well, we can take the mean of all turtles
  report mean [nb-of-children] of turtles
end
@#$#@#$#@
GRAPHICS-WINDOW
91
26
684
620
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-22
22
-22
22
0
0
1
ticks
30.0

BUTTON
11
30
75
63
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
12
76
75
109
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
700
59
872
92
initial-people
initial-people
100
1500
1100.0
100
1
NIL
HORIZONTAL

SLIDER
701
237
873
270
female-rate
female-rate
0
1
0.5
0.1
1
NIL
HORIZONTAL

SLIDER
701
198
880
231
life-expectancy
life-expectancy
20
80
70.0
5
1
NIL
HORIZONTAL

SLIDER
954
60
1126
93
average-commitment
average-commitment
0
50
25.0
5
1
NIL
HORIZONTAL

SLIDER
953
107
1155
140
average-coupling-tendency
average-coupling-tendency
0
1
0.9
0.1
1
NIL
HORIZONTAL

PLOT
703
293
1119
492
Population
years
NIL
0.0
200.0
0.0
10.0
true
true
"" ""
PENS
"total" 1.0 0 -12895429 true "" "plot count turtles"
"children" 1.0 0 -12087248 true "" "plot count turtles with [age < 18]"
"single" 1.0 0 -3844592 true "" "plot count turtles with [coupled? = false and age > 18]"

MONITOR
1136
296
1207
341
Population
count turtles
17
1
11

MONITOR
1137
348
1195
393
Children
count turtles with [age < 18]
17
1
11

MONITOR
1137
402
1260
447
% of children (>18)
count turtles with [age < 18] / count turtles
2
1
11

MONITOR
1142
502
1267
547
fecondity-rate
fecundity
3
1
11

PLOT
704
500
1119
620
Fecundity-rate
NIL
NIL
0.0
200.0
0.0
8.0
false
false
"" ""
PENS
"fecondity" 1.0 0 -13791810 true "" "plot fecundity"

SLIDER
700
108
872
141
adult-age
adult-age
10
30
18.0
1
1
NIL
HORIZONTAL

SLIDER
700
154
886
187
menopause_andropause
menopause_andropause
35
100
65.0
5
1
NIL
HORIZONTAL

SLIDER
955
153
1127
186
max-children
max-children
2
9
6.0
1
1
NIL
HORIZONTAL

SLIDER
956
199
1128
232
cost-of-child
cost-of-child
50
500
90.0
10
1
NIL
HORIZONTAL

TEXTBOX
709
16
971
44
Constraints and setup parameters
11
0.0
1

@#$#@#$#@
## WHAT IS IT?

Reproduction Ground Level

Reproduction Ground Level is a simplified demography model that aims at analysing the reproduction dynamics of a small population by simulating different social and economical behaviors as well as biological parameters.

Demography is a fascinating field where very small changes to one equation's parameters can lead either to an explosion or a population demise. Parameterization can be as complex as life is and some combinations of circumpstances can lead to varied and complex results. 
Demography, although individuals have their own goals and wills, still obeys, at the big picture level, to differentials equations with surprising precision. 
The topic has also been high on the agenda of many countries either to curb demographic expansion or support child birth. 
This models aims at exploring how some parameters impact the way a society "reproduces itself" meaning, impact the number of kids it is going to bring to life, taking into account simple mechanisms and constraints. It can be a base for exploring some other phenomenon that we will detail later. 

## HOW IT WORKS

Model rules and setups:
An intial number of individuals is set. These individuals will age and during their life, have the opportunity to reproduce if certain constraints are respected. They will die after having reached a certain lifetime. Individuals are differentiated according to several factors : 

	- age: they age at each tick and evolve from kids (white and small) to adult (big and orange or green) and, at the end of their life, reach menopause or andropause and finally die. They get their gender at birth but their color only changes at adult age. Sliders around age that the user can play with are: life-expectancy, adult-age, menopause-andropause. 

	- gender: there are 2 biological genders: male (orange) and female (green). The female rate in the society is a parameter that can vary in order to observe gender imbalance phenomenon either setup from the start or from one point onward. This will define the % of women in new born individuals. 

	- a relationship status: they can be in a couple and have a partner, or single. We also record relationship length.  

	- a lineage: a mother and a father for kids and a nb of children for adults. Life being harsh, when kids reach adult-age, they lose their mother and father which become 'nobody'.

	- financial ressources. Again, our model is a harsh and unequal world where ressources are set at birth and do not evolve during adult life. The only way for individuals to provide more ressources for their child is to associate with weathier individuals through a couple, but they couple at random, there is no specific incentive for this in this version of the model. Low ressources (meaning below the parameter called "cost of child") do not prevent individuals from having a child. Children are born and are each given, as ressource, the equivalent of 50% of their mother ressources + 50% of their father's but if, when reaching adult age, it is not enough, these children dies. The reason is that, this way, you can add events during childhood that will impact ressources: can be their parent breakup / divorce (negative impact) or, let's imagine meritocracy (professional diploma, positive impact), etc. 

	- Coupling behaviors: average coupling tendency and relationship average duration are set as paramter in the model. They are taken directly from the HIV model. In general : the coupling dynamics is inspired by the HIV model in the model librairy. 



Mechanisms / Main functions: 

Turtles are set to move around, find potential partners, couple, and stop moving for the time of their relationship, then, might break up and uncouple. This part of the model is inspired from the HIV model. 

Some functions have been added though: 

- die if reaching life expenctancy limit

- widowhood : the death function has to be taken into account for uncoupling otherwise turtles end up being the partner of dead people.

- reproduce : of course this is the function that will get the most attention as nb of kids a society produces is the point of interest here. Reproduction obeys a certain number of constrainsts detailed below. Once a baby is born, the mother and father turtle in the couple become its parents until it reaches adult age. The baby then also moves around freely. The nb of chidren of each individuals is capped by a max number of children: it can either be considered a biological constraint or a societal one ("one child policy"). 

- children-education: this function has been set now to do one thing but could easily be extended to other goals. It penalises missing parents: if both parents are dead: the child dies. If the parents are no more in a relationship: the mother abandons its child and the father will have to be the only respondent (child ressources become 0.5% of father). Mothers are terrible beings in our model. For rich individuals, this might not be a problem but it condemns "poor dads" children. 


Model constraints for reproduction :
In the model, reproduction obeys 2 types of constraints: biological, societal and economic. 

          -biological constraints: 
			-a baby can only be born from a couple -> 2 individuals : cloning is not allowed in our model and surrogacy does not exist. 
			-only a male a female couple can produce a child : this is our biological constraint but it is very easy to imagine the possible societal mechanisms one could create for non heterosexual couple. The female is the one to reproduce in the code (one has to take this role otherwise both clone themselves..). 
			- individuals cannot conceive after menopause / andropause. 
			- underaged people cannot reproduce and cannot be engaged in a relationship: no pedophilia allowed in our world.
			-max nb-of-children : biology sets a max number of children a women and a man can have in her lifetime. For now the constraint is symetric (same for men and women) but you can easily modify the model to set it as or asynmetric if you want (limit for one and not the other). 
			-at each pregnancy, the women can give birth to either one, 2 or 3 children with an equal probaility of 1/3 : in our world, having twins and triplets is as much likely as having one child. 

        
	-societal constraints:
			- only heterosexuality exists for now (this is a base model ...)
			- only the male side initiate flirting (similar to the "righties /lefties" in the HIV model). This might seem like a very conservative choice but it is much easier computationally to have one side only making the move. It was also tried to create righties and lefties for flirt on top of the male and female divide (meaning flirty men, flirty women, shy women and shy men) but it would then square down the odds for having them couple. Indeed, adding another constraint made it too unlikely to have them match, especially if we want to keep the total population to a reasonable number. Then, the choice of men for that role was made only because otherwise: women would make all the work in the model : reproducing, abandoning their children and flirting, and men would only be passive beings. However, both sides can equally initiate breakups. 
			- no couple with underaged kids : pedophilia is not allowed (can be considered as either biological or societal constraint..)
			- the couple must have had some time together in order to make a kid: in the model the relationship must be at least 2 years old to have a child (hardcoded). This penalizes the individuals that have shallow comittment. 



	-economic constraints: 
			- if a child reaches adult age and have ressources below the "cost of child", he or she dies. This can be either that the ressources it inherited at birth from his two parents are not enough or that one parent got anway and abandoned them. 


Parameters to play with:

	- initial people: initial condition makes a great difference as too scarce societies have higher chances to disappear.

	- life-expectancy

	- adult-age: set at 18 initially

	- menopause-andropause

	- female-rate 

	- max-nb-of-children

	- cost-of-child
	
	- coupling tendency relfect the easiness with which a single person will engage in a relationship with another. It implies individuals are choosing their partner and there is no allocation system such as arranged marriages. It can translate some level of hastiness in coupling versus more reserve. It is set for each individuals from a normal tendency for which the user can set the average 

	- comittment length is set for each individuals from a normal tendency for which the user can set the average 


Remark: after reading the list of constraints, one may think that our model is very conservative. Let's say our model is closer in its rules and dynamics to those of the first human societies (or at least some like ancient Chinese or ancient european ones) since it is easier to build computationnally and conceptually. We do not ignore the diversity in social or economics behaviors of ancient societies but simply want to make the model start somewhere and perform first interesting simulations. The goal is to setup "simplified" building blocks and then proceed to create more sophisticated mechanisms on top of it, whether social or economic. The goal should not be considered as highlighing one model of society or promote one against another. We hope to discover dynamics we did not expect and have no predefined anwser as to which model of society could generate more children. 


## HOW TO USE IT

The SETUP button creates individuals with a particular attribute, ressources and behavioral tendencies according to the values of the interface’s sliders. GO starts the simulation and runs it continuously until GO is pushed again. During a simulation initiated by GO, adjustments in sliders can affect the behavioral tendencies of the population.
A plot and pairs of monitors show the total count of the population as well the percentage of children and single people. 
Another monitor shows fecundity rate : or nb of children per individuals. It is then very easy to compare this to what we know from standard demographics and predict how fast the population will grow or collapse. 
In this model each time-step is considered one year; the number of years that have passed is shown in the toolbar. It is then pretty fast to go through several generations. 

The user can play with the different sliders and quickly have a feel of what factors will have the most weight in the differentials equations and test several situations. 


## THINGS TO NOTICE

We can list a series of features of / reflexions around the model: 

- a society must have a reasonable initial density to survive. With a very low number of initial people, maintaining a population is very difficult and necessitates women to have 6 or 7 children each. Reason is a lower probability to match with people meeting all the good criteria. Some mechanism like the high probability of having twins or triplets plays to alleviate this imperative. 

- demographics always have a big inertia : effects are usually slow to come and slow to adjust (except for some very striking ones like max number of children or life expectancy). In particular, once an important population decline has been initiated in our model, there is nearly nothing that can prevent the complete population collapse.

- One child policy : The most impactful variable, once you have a reasonable initial population density, is the max number of children. One can easily observe the effect of a one child policy and how fast the population collapse can take place. On the other side, allowing for a very high max number of children can ensure population will maintain itself under many circumpstances. Even if most women have 2 or 3 children, the weight of numerous families is very significant in the model. 


- Shortening life expectancy. After max number of children, this is the factor that brings the steepest population decline even if there is no impact on fecundity rate and that the curve is much less steep (if you shorten it to say age 50).

- Gender imbalance : One can also play with gender imbalance and see, from an intial female rate of 0.5 %, how many generations it takes to see population collapse if that female rate is modified on course. The profile of this collapse, though, is not super steep. There is a lot of inertia in this parameter specifically as you need several generation to replace female by overnumerous new males. 

- When to set adult-age ? Adult age is also pretty high in the ranking of sensitive variables. Lowering the period of child upbringing, meaning bringing more people in the couple market earlier and longer, is a very fast booster to fecundity even if is can be rightly considered amoral. 


- Comparing the curve for nb of children and number of sinlge people is interesting to look at (knowing some single people do have children) and evolve in cycles.


## THINGS TO TRY

There are several things to check and try with the model: 

- What is the best model for the countryside (for a low density population) ? Considering the "mother abandonning child" mechanism and 2 years necessity for a relationship to bear fruits, families are penalized if they do split up too often. This is compensated, on the other side by a higher nb of opportunities of having pregnancies. In a setup with initial dense population: the comittment length parameter does not play a big part but in lower density population ("countryside"), it brings population decline much faster and more brutally. In a "countryside" setup, a longer comittment maintains the population much longer in time (320 generations against 180 under "short" commitment policy). 

- Cloning: in the implementation of the model, before seting up couples, one can experiment cloning (meaning turtles hatching without any couple constraint). Cloning is by far, the model that brings most children, under unchanged economic parameters.
There is only if the price  of cloning is extremely high or very constrainted by society that it does not produce overpopulation. Removing the coulping needs, regardless of all ethical aspects, is, from our model, the most fruitful mechanism.



## EXTENDING THE MODEL

As mentionned before, the model offers lots of extension possibilities. Let's list some of them according to the different constraints we defined earlier: biological, economic and societal. 

Biological : 

- Fertility: in our model, we do not take into account infertility. We could even make it asymmetric between males and females. In addition, in our model, a couple ready to reproduce can have either one, two, three children in the same pregrancy with a chance of 1/3 each. This is not relfecting reality and one could change the probability governing the occurrence of twins and triplets or even favor them... 

- Other reproduction methods : In our model we need a man and a woman under menopause and andropause age and above adult age to make a child. One could consider: 
	- Medically assisted procreation: this could come as a counter effect to infertility. It could also be capped by level of ressources. 
	- Surrogacy : unions of, say, homosexual couple would not be bound to result in infertility for the couple.
	- Cloning. For cloning, a simple modification to the model shows that it greatly increases the population reproduction rate and if, on top of it, we remove the necessity to be coupled to have children, then the population is very likely to explode in most of the circumpstances. 

- Biological sex change (like grouper fish when their male dies) in order to adapt to a low female rate for example or maximize the coupling opportunities. 

- Gender biological asymmetry : the model creates two batches of turtles : males and females and sets the same life package for them but one could create inequalities on both sides: on life expectancy, on max-nb-of children, on menopause / andropause ag, etc.

- In breeding. Unfortunately, in our model, even if we make children move away from their parents once they are born, it is very likely that they sometimes come across their own relatives and engage in relationship with them. If we make a model which tracks family links much deeper, one could forbid in-breeding or penalize the survival chances of in-bred children. 


Societal : 

- Attractiveness : one could define an attractiveness level for each individual which will help them coupling. They would attract relationships more or less easily and  resettle more or less easily. 

- Homosexuality : without any form of medically assisted procreation same sex couple would be an equivalent to infertility, this is why the association of the two could play a big part. 

- Polygamy and andogamy: either both being allowed or only one of them. If associated with attractiveness, ressources or shallow committment, these structures and their occurrence would be very interesting to look at. 

- Age defined coupling tendency: in our model individuals engage with 20 years old or 60 years old without making any difference: one could set a general tendency to couple with people of same age. 

- Gender behavioral asymmetry : same principle as for biological asymetry, we could define different societal rules and behaviors for each gender: ex women more flirty than men; men breaking up more easily or having longer comittment, etc. 

- Shared parenthood: in our model, parents are the first responsible for children and they give them their ressources. One could imagine a society where responsibilities are not mainly held by parents and where ressources are set for children not given their parents' ressources but given average society ressources. This would ressemble some communist experiences of breaking the traditional family model and implement an equalitarian model for kids education. 

- Considering extended family frameworks: contrary to the previous proposition, one could think of not only involving one individuals' parents in its future but also grand parents, siblings and larger family environment: this would involve mechanism of family support and create group dynamics. 


Economic: 

- Ressource gain mechanism: one could set up a probability to increase ones ressources through several mechanims: professional training, higher education, chance, etc. Some reproductive methods could be available only to richer individuals like surrogacy. 

- Social Equality level : we could enable user to set the standard deviation of initial ressource allocation. Then, one could compare different reaction of the model to the combination of equality level and cost-of-children (which is a proxy for cost of living). Thus, how would fecundity rate react in a : unequal and poor society; unequal but overall rich society; equal and rich; or equal and poor ? 

- Infantile mortality: this would add up to the ressources constraint: one constraint at birth (being a bit biological but also economic as it reflects the health system quality of a society) and one constraint when reaching adult age. This would make it much for difficult for poorer families to have a high nb of children. 


Architecture: 

One interesting extension of the model would be : 
1. to set up the goal for individuals of making a max number of children (at the moment they do reproduce if circunstances are gathered but it is not their life goal).
2. To pass some parameters as variables and observe how they would adjust in a model that looks at maximizing number of children. For instance, imagine you put comittment length as a variable; then, would a society with a big gender imbalance become more or less monogamous ?
In the same example, how would comittment react to a very low andropause/menopause age ? 


## NETLOGO FEATURES

Minimum Initial number of people: the higher the number of people, the esasier it is to maintain a population alive cause below a certain populatio density threshold, as coupling opportunity as less probable, it is much more difficult for a population not to die out. On the other side, a big population slows the process down. So the user has to play around with parameters knowing that initial number of people will always play a part. 

Some features linked to turtles are set under a normal rule (coupling behaviors) and some under a uniform random rule : so one has to be bear it in mind when looking at resulting variables. 

Gender differentiation: as already mentioned, the model as it is now does not implement asymmetry between males and females except on reproduction features. But 2 bacthes of turtle have been created in the setup, so one can easily implement modification and add gender asymetry if one want. 

Assignment to motherhood and fatherhood which establish a link between the turtles and the consequence on one turtle of other turtle behavior (here it s parent/child relationship but it could be extended to other links : extended family with siblings, grand parents, etc. and support from a bigger family or community; influence as well from the family onto the individual, etc.


## RELATED MODELS

HIV: a model describing the spread of the human immunodeficiency virus (HIV), via sexual transmission, through a small isolated human population. 

Rabbits Grass Weeds : a model that explores a simple ecosystem made up of rabbits, grass, and weeds with rabbits reproducing under certain energy conditions. 

## CREDITS AND REFERENCES

@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

female
false
0
Circle -7500403 true true 170 5 80
Polygon -7500403 true true 165 90 180 195 150 285 165 300 195 300 210 225 225 300 255 300 270 285 240 195 255 90
Rectangle -7500403 true true 187 79 232 94
Polygon -7500403 true true 255 90 300 150 285 180 225 105
Polygon -7500403 true true 165 90 120 150 135 180 195 105
Rectangle -7500403 true true 180 225 225 300

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

male
false
0
Circle -7500403 true true 50 5 80
Polygon -7500403 true true 45 90 60 195 30 285 45 300 75 300 90 225 105 300 135 300 150 285 120 195 135 90
Rectangle -7500403 true true 67 79 112 94
Polygon -7500403 true true 135 90 180 150 165 180 105 105
Polygon -7500403 true true 45 90 0 150 15 180 75 105

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person lefty
false
0
Circle -7500403 true true 170 5 80
Polygon -7500403 true true 165 90 180 195 150 285 165 300 195 300 210 225 225 300 255 300 270 285 240 195 255 90
Rectangle -7500403 true true 187 79 232 94
Polygon -7500403 true true 255 90 300 150 285 180 225 105
Polygon -7500403 true true 165 90 120 150 135 180 195 105

person righty
false
0
Circle -7500403 true true 50 5 80
Polygon -7500403 true true 45 90 60 195 30 285 45 300 75 300 90 225 105 300 135 300 150 285 120 195 135 90
Rectangle -7500403 true true 67 79 112 94
Polygon -7500403 true true 135 90 180 150 165 180 105 105
Polygon -7500403 true true 45 90 0 150 15 180 75 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
