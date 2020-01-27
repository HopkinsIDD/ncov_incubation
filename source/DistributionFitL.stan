data {
  int <lower=0> N; //number of observations
  
  //Exposure interval
  real EL[N]; //lower end of exposure periods
  real ER[N]; //upper end of exposure period
 
  //symptom onset interval
  real SL[N];
  real SR[N];
}


parameters {
  real lm; //the mean of the log normal distribution on the log scale
  real <lower=0> lsd; //the sd of the log normal distribution on the log scale

  real E[N]; //the time of the infecting exposure
}

transformed parameters {
  real LEN_IP_LONG[N]; //the maximum length of the incubation period
  real LEN_IP_SHORT[N]; //the shortest length of the incubation period


  for (i in 1:N) {
    LEN_IP_LONG[i] <- SR[i]-E[i]+0.001;

    if (E[i]<SL[i]) {
      LEN_IP_SHORT[i] <- SL[i] - E[i]+0.001;
    } else {
      LEN_IP_SHORT[i] <- 0.001;
    }
  }
 
}

model {
  
  lm ~ normal(0,1000);//uninformative prior
  lsd ~ uniform(0,5); //uninformative prior

  E~uniform(EL,ER); //exposure in exposure period
 
  //increment probability based on the probability mass inbetween the twe length
  for (i in 1:N) {
    increment_log_prob(log(lognormal_cdf(LEN_IP_LONG[i], lm, lsd) - lognormal_cdf(LEN_IP_SHORT[i], lm, lsd)));
  }
  
}