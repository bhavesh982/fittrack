import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fittrackai/Screens/home/WorkoutProgramPage.dart';
import 'package:flutter/material.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}


class _ExerciseScreenState extends State<ExerciseScreen> with AutomaticKeepAliveClientMixin{
  // Sample data for exercises (replace with your actual data)
  void addToFireStore() async{
      final uid= FirebaseAuth.instance.currentUser!.uid;
      final ref=await FirebaseFirestore.instance.collection('users').doc(uid);
      final programData=
        {
          "POWERLIFTING PROGRAM": {
            "WEEK1": {
              "DAY1": {
                "SQUAT": {
                  "set1": { "reps": 5, "weight": "65% 1RM" },
                  "set2": { "reps": 5, "weight": "65% 1RM" },
                  "set3": { "reps": 5, "weight": "65% 1RM" }
                },
                "BENCH PRESS": {
                  "set1": { "reps": 5, "weight": "65% 1RM" },
                  "set2": { "reps": 5, "weight": "65% 1RM" },
                  "set3": { "reps": 5, "weight": "65% 1RM" }
                },
                "DEADLIFT": {
                  "set1": { "reps": 5, "weight": "70% 1RM" }
                },
                "OVERHEAD PRESS (Optional)": {
                  "set1": { "reps": 8, "weight": "As Needed" },
                  "set2": { "reps": 8, "weight": "As Needed" },
                  "set3": { "reps": 8, "weight": "As Needed" }
                }
              },
              "DAY2": {
                "REST": {
                  "set1": { "reps": 0, "weight": 0 },
                  "set2": { "reps": 0, "weight": 0 },
                  "set3": { "reps": 0, "weight": 0 }
                }
              },
              "DAY3": {
                "SQUAT": {
                  "set1": { "reps": 8, "weight": "55% 1RM" },
                  "set2": { "reps": 8, "weight": "55% 1RM" }
                },
                "BENCH PRESS (Close-Grip)": {
                  "set1": { "reps": 8, "weight": "As Needed" },
                  "set2": { "reps": 8, "weight": "As Needed" },
                  "set3": { "reps": 8, "weight": "As Needed" }
                },
                "ROMANIAN DEADLIFT (RDL)": {
                  "set1": { "reps": 10, "weight": "As Needed" },
                  "set2": { "reps": 10, "weight": "As Needed" },
                  "set3": { "reps": 10, "weight": "As Needed" }
                },
                "LAT PULLDOWNS": {
                  "set1": { "reps": 12, "weight": "As Needed" },
                  "set2": { "reps": 12, "weight": "As Needed" },
                  "set3": { "reps": 12, "weight": "As Needed" }
                }
              },
              "DAY4": {
                "REST": {
                  "set1": { "reps": 0, "weight": 0 },
                  "set2": { "reps": 0, "weight": 0 },
                  "set3": { "reps": 0, "weight": 0 }
                }
              },
              "DAY5": {
                "REST": {
                  "set1": { "reps": 0, "weight": 0 },
                  "set2": { "reps": 0, "weight": 0 },
                  "set3": { "reps": 0, "weight": 0 }
                }
              },
              "DAY6": {
                "REST": {
                  "set1": { "reps": 0, "weight": 0 },
                  "set2": { "reps": 0, "weight": 0 },
                  "set3": { "reps": 0, "weight": 0 }
                }
              },
              "DAY7": {
                "REST": {
                  "set1": { "reps": 0, "weight": 0 },
                  "set2": { "reps": 0, "weight": 0 },
                  "set3": { "reps": 0, "weight": 0 }
                }
              }
            },
            "WEEK2": {
              "DAY1": {
                "SQUAT": {
                  "set1": { "reps": 3, "weight": "70% 1RM" },
                  "set2": { "reps": 3, "weight": "70% 1RM" },
                  "set3": { "reps": 3, "weight": "70% 1RM" }
                },
                "BENCH PRESS": {
                  "set1": { "reps": 3, "weight": "70% 1RM" },
                  "set2": { "reps": 3, "weight": "70% 1RM" },
                  "set3": { "reps": 3, "weight": "70% 1RM" }
                },
                "DEADLIFT": {
                  "set1": { "reps": 3, "weight": "75% 1RM" }
                },
                "OVERHEAD PRESS (Optional)": {
                  "set1": { "reps": 6, "weight": "As Needed" },
                  "set2": { "reps": 6, "weight": "As Needed" },
                  "set3": { "reps": 6, "weight": "As Needed" }
                }
              },
              "DAY2": {
                "REST": {
                  "set1": { "reps": 0, "weight": 0 },
                  "set2": { "reps": 0, "weight": 0 },
                  "set3": { "reps": 0, "weight": 0 }
                }
              },
              "DAY3": {
                "SQUAT": {
                  "set1": { "reps": 6, "weight": "60% 1RM" },
                  "set2": { "reps": 6, "weight": "60% 1RM" }
                },
                "BENCH PRESS (Incline Dumbbell)": {
                  "set1": { "reps": 10, "weight": "As Needed" },
                  "set2": { "reps": 10, "weight": "As Needed" },
                  "set3": { "reps": 10, "weight": "As Needed" }
                },
                "ROMANIAN DEADLIFT (RDL)": {
                  "set1": { "reps": 12, "weight": "As Needed" },
                  "set2": { "reps": 12, "weight": "As Needed" },
                  "set3": { "reps": 12, "weight": "As Needed" }
                },
                "PULL-UPS (or Lat Pulldowns)": {
                  "set1": { "reps": "AMRAP", "weight": "Bodyweight or As Needed" },
                  "set2": { "reps": "AMRAP", "weight": "Bodyweight or As Needed" },
                  "set3": { "reps": "AMRAP", "weight": "Bodyweight or As Needed" }
                }
              },
              "DAY4": {
                "REST": {
                  "set1": { "reps": 0, "weight": 0 },
                  "set2": { "reps": 0, "weight": 0 },
                  "set3": { "reps": 0, "weight": 0 }
                }
              },
              "DAY5": {
                "REST": {
                  "set1": { "reps": 0, "weight": 0 },
                  "set2": { "reps": 0, "weight": 0 },
                  "set3": { "reps": 0, "weight": 0 }
                }
              },
              "DAY6": {
                "REST": {
                  "set1": { "reps": 0, "weight": 0 },
                  "set2": { "reps": 0, "weight": 0 },
                  "set3": { "reps": 0, "weight": 0 }
                }
              },
              "DAY7": {
                "REST": {
                  "set1": { "reps": 0, "weight": 0 },
                  "set2": { "reps": 0, "weight": 0 },
                  "set3": { "reps": 0, "weight": 0 }
                }
              }
            },
            "WEEK3": {
              "DAY1": {
                "SQUAT": {
                  "set1": { "reps": 5, "weight": "75% 1RM" },
                  "set2": { "reps": 5, "weight": "75% 1RM" },
                  "set3": { "reps": 5, "weight": "75% 1RM" }
                },
                "BENCH PRESS": {
                  "set1": { "reps": 5, "weight": "75% 1RM" },
                  "set2": { "reps": 5, "weight": "75% 1RM" },
                  "set3": { "reps": 5, "weight": "75% 1RM" }
                },
                "DEADLIFT": {
                  "set1": { "reps": 5, "weight": "80% 1RM" }
                },
                "OVERHEAD PRESS (Optional)": {
                  "set1": { "reps": 8, "weight": "As Needed" },
                  "set2": { "reps": 8, "weight": "As Needed" },
                  "set3": { "reps": 8, "weight": "As Needed" }
                }
              },
              "DAY2": {
                "REST": {
                  "set1": { "reps": 0, "weight": 0 },
                  "set2": { "reps": 0, "weight": 0 },
                  "set3": { "reps": 0, "weight": 0 }
                }
              },
              "DAY3": {
                "SQUAT": {
                  "set1": { "reps": 8, "weight": "65% 1RM" },
                  "set2": { "reps": 8, "weight": "65% 1RM" }
                },
                "BENCH PRESS (Pause Reps)": {
                  "set1": { "reps": 6, "weight": "As Needed" },
                  "set2": { "reps": 6, "weight": "As Needed" },
                  "set3": { "reps": 6, "weight": "As Needed" }
                },
                "ROMANIAN DEADLIFT (RDL)": {
                  "set1": { "reps": 10, "weight": "As Needed" },
                  "set2": { "reps": 10, "weight": "As Needed" },
                  "set3": { "reps": 10, "weight": "As Needed" }
                },
                "LAT PULLDOWNS": {
                  "set1": { "reps": 12, "weight": "As Needed" },
                  "set2": { "reps": 12, "weight": "As Needed" },
                  "set3": { "reps": 12, "weight": "As Needed" }
                }
              },
              "DAY4": {
                "REST": {
                  "set1": { "reps": 0, "weight": 0 },
                  "set2": { "reps": 0, "weight": 0 },
                  "set3": { "reps": 0, "weight": 0 }
                }
              },
              "DAY5": {
                "REST": {
                  "set1": { "reps": 0, "weight": 0 },
                  "set2": { "reps": 0, "weight": "0" },
                  "set3": { "reps": 0, "weight": 0 }
                }
              },
              "DAY6": {
                "REST": {
                  "set1": { "reps": 0, "weight": 0 },
                  "set2": { "reps": 0, "weight": 0 },
                  "set3": { "reps": 0, "weight": 0 }
                }
              },
              "DAY7": {
                "REST": {
                  "set1": { "reps": 0, "weight": 0 },
                  "set2": { "reps": 0, "weight": 0 },
                  "set3": { "reps": 0, "weight": 0 }
                }
              }
            },
            "WEEK4": {
              "DAY1": {
                "REST": {
                  "set1": { "reps": 0, "weight": 0 },
                  "set2": { "reps": 0, "weight": 0 },
                  "set3": { "reps": 0, "weight": 0 }
                }
              },
              "DAY2": {
                "REST": {
                  "set1": { "reps": 0, "weight": 0 },
                  "set2": { "reps": 0, "weight": 0 },
                  "set3": { "reps": 0, "weight": 0 }
                }
              },
              "DAY3": {
                "REST": {
                  "set1": { "reps": 0, "weight": 0 },
                  "set2": { "reps": 0, "weight": 0 },
                  "set3": { "reps": 0, "weight": 0 }
                }
              },
              "DAY4": {
                "REST": {
                  "set1": { "reps": 0, "weight": 0 },
                  "set2": { "reps": 0, "weight": 0 },
                  "set3": { "reps": 0, "weight": 0 }
                }
              },
              "DAY5": {
                "SQUAT": {
                  "set1": { "reps": 1, "weight": "Heavy Single (Around 90% 1RM, or as much as good form allows)" }
                },
                "BENCH PRESS": {
                  "set1": { "reps": 1, "weight": "Heavy Single (Around 90% 1RM, or as much as good form allows)" }
                },
                "DEADLIFT": {
                  "set1": { "reps": 1, "weight": "Heavy Single (Around 90% 1RM, or as much as good form allows)" }
                }
              },
              "DAY6": {
                "REST": {
                  "set1": { "reps": 0, "weight": 0 },
                  "set2": { "reps": 0, "weight": 0 },
                  "set3": { "reps": 0, "weight": 0 }
                }
              },
              "DAY7": {
                "REST": {
                  "set1": { "reps": 0, "weight": 0 },
                  "set2": { "reps": 0, "weight": 0 },
                  "set3": { "reps": 0, "weight": 0 }
                }
              }
            }
          }

      };
      await ref.update(programData);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const WorkoutProgramPage()));
  }
  final List<Map<String, dynamic>> exercises = [
    {
      'name': 'Bench Press',
      'sets': [
        {'reps': '', 'weight': ''},
        {'reps': '', 'weight': ''},
        {'reps': '', 'weight': ''},
      ],
    },
    // Add more exercises here
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed:
          addToFireStore

      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Gorilla Strength Program',style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Week 1',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Monday',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true, // Prevent list from taking all available space
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  return ExerciseCard(exercise: exercises[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}

class ExerciseCard extends StatelessWidget {
  final Map<String, dynamic> exercise;

  const ExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise['name'] as String,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true, // Prevent list from taking all available space
              itemCount: exercise['sets'].length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Text('Set ${index + 1}:',style: TextStyle(color: Colors.white),),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: TextField(
                              decoration: const InputDecoration(hintText: 'Reps'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) => exercise['sets'][index]['reps'] = value,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: TextField(
                              decoration: const InputDecoration(hintText: 'Weight'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) => exercise['sets'][index]['weight'] = value,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
