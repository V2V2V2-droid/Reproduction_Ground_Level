# Reproduction_Ground_Level
An Agent Based Model for Demography dynamics


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

	- Coupling behaviors: individuals are set at birth with an average coupling tendency and relationship average duration. They are taken directly from the HIV model. In general : the coupling dynamics is inspired by the HIV model in the NetLogo model librairy. 



Mechanisms / Main functions: 

"Turtles" (or individuals) are set to move around, find potential partners, couple, and stop moving for the time of their relationship, then, might break up and uncouple. This part of the model is inspired from the HIV model. 

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



## RELATED MODELS OF THE NETLOGO LIBRARY

HIV: a model describing the spread of the human immunodeficiency virus (HIV), via sexual transmission, through a small isolated human population. 

Rabbits Grass Weeds : a model that explores a simple ecosystem made up of rabbits, grass, and weeds with rabbits reproducing under certain energy conditions. 
